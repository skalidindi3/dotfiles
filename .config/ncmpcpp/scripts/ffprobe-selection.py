#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "chafa.py",
#     "Wand",
#     "IPython",
# ]
# ///


import argparse
import json
import os
import re
import subprocess
from functools import cached_property
from pathlib import Path

# TODO: add checking
os.environ["MAGICK_HOME"] = "/opt/homebrew/opt/imagemagick"
import chafa
from chafa.loader import Loader


def escape(infostr):
    return infostr.rstrip().replace('\x0f', '').replace("'", "\\'").replace('"', '\\"').replace('(', '\\(').replace(')', '\\)').replace('!', '\\!')


BOLD = "\x1b[1m"
GREEN = "\x1b[0;32m"
GRAY = "\x1b[0;37m"
BLUE = "\x1b[0;94m"
RED = "\x1b[0;31m"
RESET = "\x1b[0m"


class SoxStats:

    def __init__(self, rawstr):
        for line in rawstr.split('\n'):
            if line.startswith('RMS lev dB'):
                rms_lev_db = r'RMS lev dB\s+-?\d+\.\d+\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)'
                match = re.search(rms_lev_db, line)
                assert match is not None
                self.rms_lev_db_l, self.rms_lev_db_r = match.groups()
            if line.startswith('RMS Pk dB'):
                rms_pk_db = r'RMS Pk dB\s+-?\d+\.\d+\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)'
                match = re.search(rms_pk_db, line)
                assert match is not None
                self.rms_pk_db_l, self.rms_pk_db_r = match.groups()


class BeetsSong:

    @staticmethod
    def from_file(filepath='/tmp/ncmpcpp-highlighted.txt'):
        ansi_code_pattern = r'\x1b\[[0-9;]*m'
        with open(filepath, 'r') as f:
            ncmpcpp_line = f.readline().rstrip()

        split_ansi = re.split(ansi_code_pattern, ncmpcpp_line)
        fields = list(filter(None, split_ansi))
        if len(fields) == 3:
            fields.append('')
        if len(fields) == 4:
            fields.insert(3, '')
        return BeetsSong(*fields)

    def __init__(self, artist, track, title, album, length):
        self.artist = escape(artist)
        self.track = track.rstrip()
        self.title = escape(title)
        self.album = escape(album)
        self.length = length.rstrip()

    @cached_property
    def beet_query(self):
        return ' '.join([
            f'artist::^"{self.artist}"',
            f'album::^"{self.album}"',
            f'title::^"{self.title}"',
            f'track:"{self.track}"',
        ])

    @cached_property
    def beet_list_cmd(self):
        return f'beet ls -p {self.beet_query}'

    @cached_property
    def beet_export_cmd(self):
        return f'beet export {self.beet_query}'

    @cached_property
    def songpath(self):
        return subprocess.check_output(self.beet_list_cmd, shell=True).rstrip().decode('utf-8')

    @cached_property
    def relpath(self):
        return Path(self.songpath.split("/Library/")[1])

    @cached_property
    def info(self):
        return json.loads(subprocess.check_output(self.beet_export_cmd, shell=True).rstrip().decode('utf-8'))[0]

    @cached_property
    def samplerate(self):
        return {
            44100 : "44.1k",
            48000 : "48k",
            88200 : "88.2k",
            96000 : "96k",
            192000 : "192k",
        }[self.info["samplerate"]]

    @cached_property
    def downsample(self):
        return {
            44100 : 44100,
            88200 : 44100,
            48000 : 48000,
            96000 : 48000,
            192000 : 48000,
        }[self.info["samplerate"]]

    def display(self):
        print("\n".join([
            'Song info',
            f'{"─" * int(os.environ["COLUMNS"])}',
            f'Filename: {self.relpath.name}',
            f'Directory: {self.relpath.parent.as_posix()}',
            '',
            f'Length: {self.length}',
            '',
            f'Title: {self.info["title"] or "<empty>"}',
            f'Artist: {self.info["artist"] or "<empty>"}',
            f'Album Artist: {self.info["albumartist"] or "<empty>"}',
            f'Album: {self.info["album"] or "<empty>"}',
            f'Date: {self.info["date"] or "<empty>"}',
            f'Track: {self.info["track"] or "<empty>"}',
            f'Genre: {self.info["genre"] or "<empty>"}',
            f'Composer: {self.info["composer"] or "<empty>"}',
            'Performer: <empty>',
            f'Disc: {self.info["disc"] or "<empty>"}',
            f'Comment: {self.info["comments"] or "<empty>"}',
        ]))

    def generate_spectrogram(self, spectrogram_path='/tmp/ncmpcpp_spectrogram'):
        # https://ffmpeg.org/ffmpeg-filters.html#showspectrumpic
        spec_size = '800x240'
        spec_color = 'viridis'
        spec_cmd = f'showspectrumpic=s={spec_size}:scale=log:color={spec_color}:legend=disabled'
        # TODO: choose spec color based on codec
        subprocess.run([
            'ffmpeg',
            '-hide_banner',
            '-loglevel',
            'quiet',
            '-y',
            '-i',
            self.songpath,
            '-ar',
            str(self.downsample),
            '-c:a',
            'pcm_s24le',
            f'{spectrogram_path}.wav',
        ])
        subprocess.run([
            'ffmpeg',
            '-hide_banner',
            '-loglevel',
            'quiet',
            '-y',
            '-i',
            f'{spectrogram_path}.wav',
            '-lavfi',
            'channelsplit=channel_layout=stereo[FL][FR];'
            f'[FL]{spec_cmd}[left];'
            f'[FR]{spec_cmd}[right];'
            '[left][right]vstack=inputs=2[out]',
            '-map',
            '[out]',
            f'{spectrogram_path}.png',
        ])
        #subprocess.run([
        #    'sox',
        #    f'{spectrogram_path}.wav',
        #    '-n',
        #    'spectrogram',
        #    '-o',
        #    f'{spectrogram_path}.png',
        #    '-r'
        #])

    def ascii_spectrogram(self, height=24, width=80, spectrogram_path='/tmp/ncmpcpp_spectrogram'):
        self.generate_spectrogram(spectrogram_path=spectrogram_path)

        num_cols = int(os.environ["COLUMNS"])
        if int(num_cols * 0.8) < width:
            ratio = height / width
            width = int(num_cols * 0.8)
            height = (int(ratio * width) + 1) & 0xFFFF_FFFE

        config = chafa.CanvasConfig()
        config.height = height
        config.width = width
        canvas = chafa.Canvas(config)

        image = Loader(f'{spectrogram_path}.png')

        canvas.draw_all_pixels(
            image.pixel_type,
            image.get_pixels(),
            image.width, image.height,
            image.rowstride
        )
        return canvas.print().decode()

    def sox_stats(self, spectrogram_path='/tmp/ncmpcpp_spectrogram'):
        stats = subprocess.run([
            'sox',
            f'{spectrogram_path}.wav',
            '-n',
            'stats',
        ], capture_output=True, text=True)
        return SoxStats(stats.stderr)

    def display_alt(self):
        output = self.ascii_spectrogram()
        output_lines = output.split("\n")
        output_hi = "\n".join(output_lines[:(len(output_lines)+1)//2])
        output_lo = "\n".join(output_lines[len(output_lines)//2:])
        stats = self.sox_stats()
        print("\n".join([
            BOLD + 'Song info (advanced)' + RESET,
            f'{"─" * int(os.environ["COLUMNS"])}',
            f'{GRAY}Filename  : {BLUE}{self.relpath.name}{RESET}',
            f'{GRAY}Directory : {BLUE}{self.relpath.parent.as_posix()}{RESET}',
            '',
            f'{GRAY}Encoding  : {RED}{self.info["format"]} / {self.info["bitdepth"] or "NA"}b / {self.samplerate}{RESET}',
            '',
            f'{GRAY}Title     : {GREEN}{self.info["title"] or "<empty>"}{RESET}',
            f'{GRAY}Artist    : {GREEN}{self.info["artist"] or "<empty>"}{RESET}',
            f'{GRAY}Album     : {GREEN}{self.info["album"] or "<empty>"}{RESET}',
            f'{GRAY}Length    : {GREEN}{self.length}{RESET}',
            f'{GRAY}Disc      : {GREEN}{self.info["disc"] or "<empty>"} / {self.info["disctotal"] or "<empty>"}{RESET}',
            f'{GRAY}Track     : {GREEN}{self.info["track"] or "<empty>"} / {self.info["tracktotal"] or "<empty>"}{RESET}',
            f'{GRAY}Date      : {GREEN}{self.info["date"] or "<empty>"}{RESET}',
            '',
            BOLD + 'Spectrogram (downsampled)' + RESET,
            f'{"─" * int(os.environ["COLUMNS"])}',
            f'{BLUE}[channel L]{RESET} :: (RMS Level = {GREEN}{stats.rms_lev_db_l}dB{RESET}) :: (RMS Peak = {GREEN}{stats.rms_pk_db_l}dB{RESET})',
            output_hi,
            '',
            f'{BLUE}[channel R]{RESET} :: (RMS Level = {GREEN}{stats.rms_lev_db_r}dB{RESET}) :: (RMS Peak = {GREEN}{stats.rms_pk_db_r}dB{RESET})',
            output_lo,
            '',
        ]))


parser = argparse.ArgumentParser()
parser.add_argument("-i",
                    "--info",
                    action="store_true",
                    help="show advanced info")
parser.add_argument("-a",
                    "--art",
                    action="store_true",
                    help="open albumart")
parser.add_argument("-p",
                    "--probe",
                    action="store_true",
                    help="open ffprobe")
parser.add_argument("-s",
                    "--spectrogram",
                    action="store_true",
                    help="open spectrogram")
args = parser.parse_args()

beets_song = BeetsSong.from_file()
if args.info:
    subprocess.run(['clear'])
    beets_song.display_alt()
    subprocess.run(['read', '-n', '1'])
    subprocess.run(['clear'])
elif args.art:
    subprocess.run(['zsh', '-i', '-c', f'extract_art "{beets_song.songpath}"'])
elif args.probe:
    subprocess.run(['zsh', '-i', '-c', f'ffprobe_report "{beets_song.songpath}"'])
elif args.spectrogram:
    subprocess.run(['zsh', '-i', '-c', f'spec "{beets_song.songpath}"'])

# TODO: show lyrics in pane

