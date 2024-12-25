.PHONY: provision
provision:
	stow .
	# setup git filters
	git config filter.mpdscribble_conf_login.clean 'sed -E "s/(username|password) = .*/\1 =/"'

.PHONY: clean
clean:
	stow --delete .
