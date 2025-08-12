.PHONY: provision
provision:
	stow --no-folding .
	# setup git filters
	git config filter.mpdscribble_conf_login.clean 'sed -E "s/(username|password) = .*/\1 =/"'
	# clone tmux package manager
	git -C ~/.config/tmux/plugins/tpm pull \
			|| git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

.PHONY: install_packages
install_packages:
# NOTE: git should already be installed to clone this
ifeq ($(shell uname -s),Darwin)
	brew install \
		stow \
		git \
		neovim \
		tmux \
		curl \
		wget \
		rsync \
		ripgrep \
		fzf \
		antidote \
		zoxide \
		tree \
		moreutils \
		dust \
		fd \
		htop \
		duf \
		jq
		# NOTE: moreutils for vidir
else
ifeq ($(shell uname -s),Linux)
	sudo apt install \
		stow \
		git \
		neovim \
		tmux \
		curl \
		wget \
		rsync \
		ripgrep \
		fzf \
		zsh-antidote \
		zoxide \
		tree \
		moreutils \
		fd-find \
		htop \
		duf \
		jq
		#dust
endif
endif

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
endif

.PHONY: adopt
adopt:
	stow --no-folding --adopt -nv .

.PHONY: adopt_unsafe
adopt_unsafe:
	stow --no-folding --adopt -v .

.PHONY: clean
clean:
	stow --delete .
