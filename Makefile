.PHONY: provision
provision: provision_git provision_sh provision_tmux provision_neovim provision_mpd provision_ncmpcpp

.PHONY: provision_git
provision_git:
	@[ -f ~/.gitconfig ] \
		&& echo "~/.gitconfig already exists!" \
		|| ln -s $(abspath ./git/.gitconfig) ~/.gitconfig

# NOTE: |vim| uses the rakr/vim-one color scheme, which is compatible
#   with the https://github.com/sonph/onehalf terminal theme
.PHONY: provision_sh
provision_sh:
	@[ -f ~/.bash_aliases ] \
		&& echo "~/.bash_aliases already exists!" \
		|| ln -s $(abspath ./sh/.bash_aliases) ~/.bash_aliases
	@[ -f ~/.zshrc ] \
		&& echo "~/.zshrc already exists!" \
		|| ln -s $(abspath ./sh/.zshrc) ~/.zshrc
	@git submodule update --init --recursive

.PHONY: provision_tmux
provision_tmux:
	@mkdir -p ~/.config/tmux
	@[ -f ~/.config/tmux/tmux.conf ] \
		&& echo "~/.config/tmux/tmux.conf already exists!" \
		|| ln -s $(abspath ./tmux/.tmux.conf) ~/.config/tmux/tmux.conf

.PHONY: provision_neovim
provision_neovim:
	@mkdir -p ~/.config/nvim
	@[ -f ~/.config/nvim/init.vim ] \
		&& echo "~/.config/nvim/init.vim already exists!" \
		|| ln -s $(abspath ./vim/.vimrc) ~/.config/nvim/init.vim

.PHONY: provision_mpd
provision_mpd:
	@mkdir -p ~/.config/mpd
	@[ -f ~/.config/mpd/mpd.conf ] \
		&& echo "~/.config/mpd/mpd.conf already exists!" \
		|| ln -s $(abspath ./mpd/mpd.conf) ~/.config/mpd/mpd.conf
	@mkdir -p ~/.config/mpdscribble
	@[ -f ~/.config/mpdscribble/mpdscribble.conf ] \
		&& echo "~/.config/mpdscribble/mpdscribble.conf already exists!" \
		|| ln -s $(abspath ./mpd/mpdscribble.conf) ~/.config/mpdscribble/mpdscribble.conf

.PHONY: provision_ncmpcpp
provision_ncmpcpp:
	@mkdir -p ~/.config/ncmpcpp
	@[ -f ~/.config/ncmpcpp/config ] \
		&& echo "~/.config/ncmpcpp/config already exists!" \
		|| ln -s $(abspath ./ncmpcpp/config) ~/.config/ncmpcpp/config
	@[ -f ~/.config/ncmpcpp/bindings ] \
		&& echo "~/.config/ncmpcpp/bindings already exists!" \
		|| ln -s $(abspath ./ncmpcpp/bindings) ~/.config/ncmpcpp/bindings

.PHONY: force_clean
force_clean:
	rm -f ~/.gitconfig ~/.bash_aliases ~/.zshrc ~/.config/tmux/tmux.conf ~/.config/nvim/init.vim

