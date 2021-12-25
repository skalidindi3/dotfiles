.PHONY: provision
provision: provision_git provision_sh provision_tmux provision_neovim

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
	@[ -f ~/.tmux.conf ] \
		&& echo "~/.tmux.conf already exists!" \
		|| ln -s $(abspath ./tmux/.tmux.conf) ~/.tmux.conf

.PHONY: provision_neovim
provision_neovim:
	@mkdir -p ~/.config/nvim
	@[ -f ~/.config/nvim/init.vim ] \
		&& echo "~/.config/nvim/init.vim already exists!" \
		|| ln -s $(abspath ./vim/.vimrc) ~/.config/nvim/init.vim

.PHONY: provision_mpd
provision_mpd:
	@mkdir -p ~/.mpd
	@[ -f ~/.mpd/mpd.conf ] \
		&& echo "~/.mpd/mpd.conf already exists!" \
		|| ln -s $(abspath ./mpd/mpd.conf) ~/.mpd/mpd.conf

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
	rm -f ~/.gitconfig ~/.bash_aliases ~/.zshrc ~/.tmux.conf

