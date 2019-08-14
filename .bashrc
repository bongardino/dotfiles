# Load the shell dotfiles, and then some:
for file in ~/.{bash_prompt,exports,aliases,functions}; do
  [ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but Sam likes being explicit
complete -W "NSGlobalDomain" defaults

# Add tab completion for `aws` if installed
type aws &> /dev/null && complete -C "$(which aws_completer)" aws

# fuzzyfinder shortcuts
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# autocompletion
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# ~/.bashrc.local can be used for other settings you don’t want to commit.
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

# variables for the iterm2 component statusbar. requires nightly and stuff.
if [ $TERM_PROGRAM=='iTerm.app' ] && [ -f ~/.iterm_vars ]; then
  source ~/.iterm_vars
fi
