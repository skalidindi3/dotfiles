"""Back up conflicts before mise applies this checkout's home dotfile group.

Requires system Python 3.11+ and mise. Run with --dry-run to preview moves.
Backups retain paths relative to the group's target beneath checkout/backups/.
Backup failures restore completed moves; subsequent mise failures retain backups.
"""

from __future__ import annotations

import argparse
from collections.abc import Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import signal
import stat
import subprocess
import tempfile
import tomllib
from types import FrameType
from typing import Any, NoReturn


@dataclass(frozen=True)
class Conflict:
    """An original destination and its identity before any files are moved."""

    destination: Path
    relative_path: Path
    original_stat: os.stat_result


def mise_json(checkout: Path, *arguments: str) -> Any:
    """Read mise's active configuration without suppressing failure diagnostics."""
    result = subprocess.run(
        ["mise", *arguments, "--json"],
        cwd=checkout,
        check=True,
        stdout=subprocess.PIPE,
        text=True,
    )
    return json.loads(result.stdout)


def absolute_path(value: str) -> Path:
    """Expand mise's home abbreviation without resolving destination symlinks."""
    path = Path(value).expanduser()
    if not path.is_absolute():
        raise ValueError(f"Expected an absolute or home-relative path: {value!r}")
    return Path(os.path.abspath(path))


def discover_roots(checkout: Path) -> tuple[Path, Path]:
    """Accept only one unfiltered home group, then obtain its roots from mise."""
    own_config = checkout / "mise.toml"
    found_group = False
    for entry in mise_json(checkout, "config", "ls"):
        config_path = absolute_path(entry["path"]).resolve(strict=True)
        if config_path.suffix != ".toml":
            continue
        with config_path.open("rb") as config_file:
            config = tomllib.load(config_file)
        if config.get("dotfiles") or "dotfile_groups" in config.get("bootstrap", {}):
            raise ValueError(f"Unsupported dotfile entries or group selection in {config_path}")
        groups = config.get("dotfile_groups", {})
        if not groups:
            continue
        if config_path != own_config or set(groups) != {"home"}:
            raise ValueError(f"Only this checkout's home group is supported: {config_path}")
        group = groups["home"]
        unsupported = set(group) - {"root", "target", "mode", "relative"}
        if unsupported or group.get("mode", "symlink-each") != "symlink-each":
            raise ValueError(
                f"Expected an unfiltered symlink-each home group in {config_path}; "
                f"unsupported keys: {sorted(unsupported)}"
            )
        found_group = True
    if not found_group:
        raise ValueError(f"No supported home group found in {own_config}")

    status = mise_json(checkout, "dot", "status")
    if len(status["files"]) != 1 or status["edits"]:
        raise ValueError("Expected exactly one active dotfile group and no dotfile edits")
    entry = status["files"][0]
    if (
        entry["mode"] != "symlink-each"
        or absolute_path(entry["origin"]["config"]).resolve() != own_config
        or entry.get("omitted", 0)
        or entry.get("nested", 0)
    ):
        raise ValueError("Resolved dotfiles do not match the supported home group")
    source = absolute_path(entry["source"])
    target = absolute_path(entry["target"])
    if source == checkout or not source.is_relative_to(checkout):
        raise ValueError(f"The source must be a directory within this checkout: {source}")
    if source.is_relative_to(checkout / "backups") or target.is_relative_to(checkout):
        raise ValueError("Dotfiles must not deploy backups or write into the checkout")
    require_directory_path(source)
    source.stat()
    return source, target


def lstat_if_present(path: Path) -> os.stat_result | None:
    """Inspect a path without following its final symlink or hiding access errors."""
    try:
        return path.lstat()
    except FileNotFoundError:
        return None


def require_directory_path(path: Path) -> None:
    """Reject existing symlinks and non-directories anywhere along a directory path."""
    for ancestor in (*reversed(path.parents), path):
        information = lstat_if_present(ancestor)
        if information is not None and not stat.S_ISDIR(information.st_mode):
            raise ValueError(f"Expected a real directory, found an obstruction: {ancestor}")


def source_entries(directory: Path) -> Iterator[Path]:
    """Walk source files and directories deterministically, never following symlinks."""
    for path in sorted(directory.iterdir()):
        mode = path.lstat().st_mode
        if not (stat.S_ISREG(mode) or stat.S_ISDIR(mode)):
            raise ValueError(f"Unsupported source; expected a file or directory: {path}")
        yield path
        if stat.S_ISDIR(mode):
            yield from source_entries(path)


def discover_conflicts(checkout: Path, source: Path, target: Path) -> list[Conflict]:
    """Validate every destination before returning the originals that need backups."""
    require_directory_path(target)
    conflicts: list[Conflict] = []
    for source_path in source_entries(source):
        relative_path = source_path.relative_to(source)
        destination = target / relative_path
        if destination.is_relative_to(checkout):
            raise ValueError(f"Refusing to deploy a dotfile into the checkout: {destination}")
        information = lstat_if_present(destination)
        if source_path.is_dir():
            require_directory_path(destination)
        elif information is not None:
            if stat.S_ISLNK(information.st_mode):
                if Path(os.path.realpath(destination)) == source_path:
                    continue
            elif not stat.S_ISREG(information.st_mode):
                raise ValueError(f"Refusing to move a directory or special file: {destination}")
            conflicts.append(Conflict(destination, relative_path, information))
    return conflicts


def file_identity(information: os.stat_result) -> tuple[int, ...]:
    """Identify an original and detect changes without treating access time as an edit."""
    return (
        information.st_dev,
        information.st_ino,
        information.st_mode,
        information.st_size,
        information.st_mtime_ns,
        information.st_ctime_ns,
    )


@contextmanager
def defer_interruptions() -> Iterator[None]:
    """Deliver termination signals only after a move is recorded or rollback finishes."""
    previous_mask = signal.pthread_sigmask(
        signal.SIG_BLOCK, {signal.SIGINT, signal.SIGTERM, signal.SIGHUP}
    )
    try:
        yield
    finally:
        signal.pthread_sigmask(signal.SIG_SETMASK, previous_mask)


def restore_originals(completed: list[tuple[Conflict, Path]]) -> list[Exception]:
    """Restore in reverse order using hard links that cannot overwrite new destinations.

    Remove each backup only after its original path is restored. Linking without
    following symlinks preserves their text and fails atomically on a collision.
    """
    failures: list[Exception] = []
    for conflict, backup in reversed(completed):
        try:
            require_directory_path(conflict.destination.parent)
            if lstat_if_present(conflict.destination) is not None:
                raise FileExistsError(f"Refusing to overwrite {conflict.destination}")
            backup_stat = backup.lstat()
            if (backup_stat.st_dev, backup_stat.st_ino) != (
                conflict.original_stat.st_dev,
                conflict.original_stat.st_ino,
            ):
                raise RuntimeError(f"The backup was replaced after it was moved: {backup}")
            os.link(backup, conflict.destination, follow_symlinks=False)
            backup.unlink()
        except Exception as failure:
            failure.add_note(f"Recovery path: {backup} -> {conflict.destination}")
            failures.append(failure)
    return failures


def back_up_conflicts(checkout: Path, conflicts: list[Conflict], dry_run: bool) -> None:
    """Move originals on one filesystem, restoring completed moves on any failure."""
    if not conflicts:
        print("No dotfile conflicts to back up.")
        return
    backup_root = checkout / "backups"
    require_directory_path(backup_root)
    backup_device = (lstat_if_present(backup_root) or checkout.stat()).st_dev
    for conflict in conflicts:
        if conflict.original_stat.st_dev != backup_device:
            raise OSError(f"Cannot atomically back up across filesystems: {conflict.destination}")
    if dry_run:
        for conflict in conflicts:
            print(
                f"Would move {str(conflict.destination)!r} -> "
                f"{str(backup_root / '<UTC-timestamp>' / conflict.relative_path)!r}"
            )
        return

    backup_root.mkdir(mode=0o700, exist_ok=True)
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    backup_directory = Path(tempfile.mkdtemp(prefix=f"{timestamp}-", dir=backup_root))
    completed: list[tuple[Conflict, Path]] = []
    try:
        for conflict in conflicts:
            (backup_directory / conflict.relative_path).parent.mkdir(parents=True, exist_ok=True)
        for conflict in conflicts:
            backup = backup_directory / conflict.relative_path
            require_directory_path(conflict.destination.parent)
            if file_identity(conflict.destination.lstat()) != file_identity(conflict.original_stat):
                raise RuntimeError(f"Destination changed during backup: {conflict.destination}")
            if lstat_if_present(backup) is not None:
                raise FileExistsError(f"Refusing to overwrite backup: {backup}")
            with defer_interruptions():
                conflict.destination.rename(backup)
                completed.append((conflict, backup))
            print(f"Backed up {str(conflict.destination)!r} -> {str(backup)!r}", flush=True)
    except BaseException as failure:
        with defer_interruptions():
            restoration_failures = restore_originals(completed)
        if restoration_failures:
            raise BaseExceptionGroup(
                f"Backup failed; some originals require recovery from {backup_directory}",
                [failure, *restoration_failures],
            ) from None
        failure.add_note("All completed backup moves were restored; mise must not continue.")
        raise


def raise_interruption(signum: int, _frame: FrameType | None) -> NoReturn:
    """Turn handled termination signals into failures that trigger backup rollback."""
    raise InterruptedError(f"Dotfile backup interrupted by {signal.Signals(signum).name}")


def main() -> None:
    """Discover conflicts for this checkout and back them up before returning to mise."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="Preview backups without writes")
    arguments = parser.parse_args()
    for signum in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        signal.signal(signum, raise_interruption)
    checkout = Path(__file__).resolve().parents[1]
    source, target = discover_roots(checkout)
    conflicts = discover_conflicts(checkout, source, target)
    back_up_conflicts(checkout, conflicts, arguments.dry_run)


if __name__ == "__main__":
    main()
