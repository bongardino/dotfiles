TODO :
- [x] Move repo out of home dir to src
- [x] come up w a more clever alias name
- [x] build into warm welcome
- [ ] fix that terrible bash script

[Source](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/ "Permalink to The best way to store your dotfiles: A bare Git repo")

> No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation.

The technique consists in storing a Git bare repo in a "_side_" folder (like `$HOME/.dots` or `$HOME/src/dotfiles`) using a specially crafted alias so that commands are run against that repo and not the usual `.git` local folder, which would interfere with any other Git repositories around.

## Starting from scratch

If you haven't been tracking your configurations in a Git repo before, you can start using this technique easily with these lines:
    
    
    git init --bare "$HOME"/src/dotfiles
    alias dot_git='/usr/bin/git --git-dir=$HOME/src/dotfiles/ --work-tree=$HOME'
    dot_git config --local status.showUntrackedFiles no
    echo "alias dot_git='/usr/bin/git --git-dir=$HOME/src/dotfiles/ --work-tree=$HOME'" >> "$HOME"/.bashrc

* The first line creates a folder `~/src/dotfiles` which is a Git bare repo that will track our files.
* Then we create an alias `dot_git` which we will use instead of the regular `git` when we want to interact with our configuration repo.
* We set a flag - local to the repo - to hide files we are not explicitly tracking yet. This is so that when you type `dot_git status` and other commands later, files you are not interested in tracking will not show up as `untracked`.
* Also you can add the alias definition by hand to your `.bashrc` or use the the fourth line provided for convenience.

After you've executed the setup any file within the `$HOME` folder can be versioned with normal commands, replacing `git` with your newly created `dot_git` alias, like:
    
    
    dot_git status
    dot_git add .vimrc
    dot_git commit -m "Add vimrc"
    dot_git add .bashrc
    dot_git commit -m "Add bashrc"
    dot_git push

## Install your dotfiles onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a Git repo, on a new system you can migrate to this setup with the following steps:

* Prior to the installation make sure you have committed the alias to your `.bashrc`:
    
        alias dot_git='/usr/bin/git --git-dir=$HOME/src/dotfiles/ --work-tree=$HOME'

* And that your source repo ignores the folder where you'll clone it, so that you don't create weird recursion problems:
    
        echo "dotfiles" >> .gitignore

* Now clone your dotfiles into a bare repo in a _"dot"_ folder of your `$HOME`:
    
        git clone --bare git@github.com:bongardino/dotfiles.git "$HOME"/src/dotfiles

* Define the alias in the current shell scope:
    
        alias dot_git='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'

* Checkout the actual content from the bare repo to your `$HOME`:
    
        dot_git checkout

* The step above might fail with a message like:
```    
        error: The following untracked working tree files would be overwritten by checkout:
        .bashrc
        .gitignore
    Please move or remove them before you can switch branches.
    Aborting
```
This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:
```
    mkdir -p /Desktop/config-backup && 
    dots2git checkout 2>&1 | egrep "[.]+[a-z]" | awk {'print $1'} | xargs -I{} mv {} "$HOME"/Desktop/config-backup/
```
* Re-run the check out if you had problems:
    
        dot_git checkout

* Set the flag `showUntrackedFiles` to `no` on this specific (local) repo:
    
        dot_git config --local status.showUntrackedFiles no

* You're done, from now on you can now type `dot_git` commands to add and update your dotfiles:
```
    dot_git status
    dot_git add .vimrc
    dot_git commit -m "Add vimrc"
    dot_git add .bashrc
    dot_git commit -m "Add bashrc"
    dot_git push
```

For completeness this is what I ended up with for OS X
    
```
#!/bin/bash
# this is terrible and not safe dont use it I was up late

git clone --bare https://github.com/bongardino/dotfiles.git "$HOME"/src/dotfiles

function dot_git {
   /usr/bin/git --git-dir="$HOME"/src/dotfiles/ --work-tree="$HOME" $@
}

if [ ! -d "$DIRECTORY" ]; then
	mkdir -p "$HOME"/Desktop/config-backup
fi

dot_git checkout

if [ $? = 0 ]; then
  echo "Checked out dots.";
  else
    echo "Backing up pre-existing dot files.";
    dots2git checkout 2>&1 | egrep "[.]+[a-z]" | awk {'print $1'} | xargs -I{} mv {} "$HOME"/Desktop/config-backup/
fi;

dot_git checkout
dot_git config status.showUntrackedFiles no
```

## My gitignore file is EXPLICIT to avoid terrible mistakes - make sure to add new files to the whitelist

