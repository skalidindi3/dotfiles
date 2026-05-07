.PHONY: provision
provision:
	stow --no-folding .
	# setup git filters
	git config filter.mpdscribble_conf_login.clean 'sed -E "s/(username|password) = .*/\1 =/"'
	# clone tmux package manager
	mkdir -p ~/.config/tmux/plugins
	git -C ~/.config/tmux/plugins/tpm pull \
			|| git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

.PHONY: install_packages
install_packages:
# NOTE: git should already be installed to clone this
# NOTE: linux assume sudo apt install curl git xclip make build-essential openssh-server net-tools zsh
	brew install \
		stow \
		lazygit \
		neovim \
		tmux \
		curl \
		wget \
		rsync \
		ripgrep \
		fzf \
		antidote \
		zoxide \
		lsd \
		moreutils \
		dust \
		fd \
		htop \
		duf \
		jq \
		mise
		# NOTE: moreutils for vidir

.PHONY: install_extra
install_extra:
ifeq ($(shell uname -s),Darwin)
	brew install --cask rar
	brew install \
		mpd \
		mpdscribble \
		ncmpcpp \
		exiftool \
		android-platform-tools
	uv tool install --from git+https://github.com/skalidindi3/osxmpdkeys osxmpdkeys
endif

.PHONY: adopt
adopt:
	stow --no-folding --adopt -nv .

.PHONY: adopt_unsafe
adopt_unsafe:
	stow --no-folding --adopt -v .

.PHONY: run_mpd
run_mpd:
	pgrep -x mpd || mpd ~/.config/mpd/mpd.conf
	pgrep -x mpdscribble || mpdscribble --conf ~/.config/mpdscribble/mpdscribble.conf
	pgrep -f mpdkeys || nohup mpdkeys &>/dev/null &

.PHONY: clean
clean:
	stow --delete .
