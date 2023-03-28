eval "$(/opt/homebrew/bin/brew shellenv)"

# Load the shell dotfiles, and then some:
for file in $HOME/.{bash_prompt,exports,aliases,functions,iterm2}; do
  [ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
# this needs some fixing w multiple shells but it isnt making me angry atm
# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but Sam likes being explicit
complete -W "NSGlobalDomain" defaults

# If possible, add tab completion for these things
brewery=$(brew --prefix)
[[ -s $brewery/etc/profile.d/bash_completion.sh ]] && source $brewery/etc/profile.d/bash_completion.sh
[[ -s $brewery/opt/fzf/shell/completion.bash ]] && source $brewery/opt/fzf/shell/completion.bash
[[ -s $brewery/opt/fzf/shell/key-bindings.bash ]] && source $brewery/opt/fzf/shell/key-bindings.bash

# and these things
for file in $brewery/etc/bash_completion.d/*; do
  [ -r "$file" ] && source "$file"
done
unset file

# https://github.com/cykerway/complete-alias
[ -r "$HOME/src/complete-alias/complete_alias" ] && source "$HOME/src/complete-alias/complete_alias"

# ~/.bashrc.local can be used for other settings you don’t want to commit.
if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi

# https://github.com/pyenv/pyenv-virtualenv#installing-with-homebrew-for-macos-users
# if type pyenv &> /dev/null; then
#   eval "$(pyenv virtualenv-init -)"
# fi

# are you happy now?
if [ -f $HOME/.bootstrap/env.sh ]; then
  source $HOME/.bootstrap/env.sh
fi

export LDFLAGS="-L$(brew --prefix)/opt/libffi/lib"

export CPPFLAGS="-I$(brew --prefix)/opt/libffi/include"

export PKG_CONFIG_PATH="$(brew --prefix)/opt/libffi/lib/pkgconfig"

source "$HOME/.bootstrap/env.sh"
