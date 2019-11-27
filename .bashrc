# Load the shell dotfiles, and then some:
for file in ~/.{bash_prompt,exports,aliases,functions,iterm2}; do
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

# If possible, add tab completion for many more commands
brewery=$(brew --prefix)
[[ -s $brewery/etc/profile.d/bash_completion.sh ]] && source $brewery/etc/profile.d/bash_completion.sh
[[ -s $brewery/etc/bash_completion.d/git-completion.bash ]] && source $brewery/etc/bash_completion.d/git-completion.bash
[[ -s $brewery/opt/fzf/shell/completion.bash ]] && source $brewery/opt/fzf/shell/completion.bash
[[ -s $brewery/opt/fzf/shell/key-bindings.bash ]] && source $brewery/opt/fzf/shell/key-bindings.bash


# ~/.bashrc.local can be used for other settings you don’t want to commit.
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

# are you happy now?
source "$HOME/.bootstrap/env.sh"
