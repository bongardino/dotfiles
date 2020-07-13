# Load the shell dotfiles, and then some:
for file in $HOME/.{bash_prompt,exports,aliases,functions,iterm2}; do
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

# If possible, add tab completion for these things
brewery=$(brew --prefix)
[[ -s $brewery/etc/profile.d/bash_completion.sh ]] && source $brewery/etc/profile.d/bash_completion.sh
[[ -s $brewery/opt/fzf/shell/completion.bash ]] && source $brewery/opt/fzf/shell/completion.bash
[[ -s $brewery/opt/fzf/shell/key-bindings.bash ]] && source $brewery/opt/fzf/shell/key-bindings.bash

# ~/.bashrc.local can be used for other settings you don’t want to commit.
if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi

# are you happy now?
source "$HOME/.bootstrap/env.sh"
