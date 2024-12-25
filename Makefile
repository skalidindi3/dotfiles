.PHONY: provision
provision:
	stow .
	# setup git filters
	git config filter.mpdscribble_conf_login.clean 'sed -E "s/(username|password) = .*/\1 =/"'

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
		zoxide \
		tree \
		moreutils \
		dust \
		fd \
		htop \
		duf \
		jq
		# NOTE: moreutils for vidir
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

.PHONY: clean
clean:
	stow --delete .
