# Load the shell dotfiles, and then some:
for file in ~/.{bash_prompt,exports,aliases,functions,bashrc.local}; do
  [ -r "$file" ] && source "$file"
done
unset file

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but Sam likes being explicit
complete -W "NSGlobalDomain" defaults

# Add tab completion for `aws` if installed
type aws &> /dev/null && complete -C "$(which aws_completer)" aws

# ~/.bashrc.local can be used for other settings you don’t want to commit.
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

# fuzzyfinder shortcuts
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# autocompletion
#OLD autocomplete for old bash I think# [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
