
[Source](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/ "Permalink to The best way to store your dotfiles: A bare Git repository")

> No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation.

The technique consists in storing a [Git bare repository][5] in a "_side_" folder (like `$HOME/.dots` or `$HOME/.myconfig`) using a specially crafted alias so that commands are run against that repository and not the usual `.git` local folder, which would interfere with any other Git repositories around.

## Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:
    
    
    git init --bare "$HOME"/.dots
    alias dots2git='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
    dots2git config --local status.showUntrackedFiles no
    echo "alias dots2git='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'" >> "$HOME"/.bashrc

* The first line creates a folder `~/.dots` which is a [Git bare repository][5] that will track our files.
* Then we create an alias `config` which we will use instead of the regular `git` when we want to interact with our configuration repository.
* We set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type `config status` and other commands later, files you are not interested in tracking will not show up as `untracked`.
* Also you can add the alias definition by hand to your `.bashrc` or use the the fourth line provided for convenience.

I packaged the above lines into a [snippet][6] up on Bitbucket and linked it from a short-url. So that you can set things up with:
    
    
    curl -Lks http://bit.do/cfg-init | /bin/bash

After you've executed the setup any file within the `$HOME` folder can be versioned with normal commands, replacing `git` with your newly created `config` alias, like:
    
    
    dots2git status
    dots2git add .vimrc
    dots2git commit -m "Add vimrc"
    dots2git add .bashrc
    dots2git commit -m "Add bashrc"
    dots2git push

## Install your dotfiles onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a [Git repository][4], on a new system you can migrate to this setup with the following steps:

* Prior to the installation make sure you have committed the alias to your `.bashrc` or `.zsh`:
    
        alias dots2git='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'

* And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:
    
        echo ".dots" >> .gitignore

* Now clone your dotfiles into a [bare][5] repository in a _"dot"_ folder of your `$HOME`:
    
        git clone --bare  $HOME/.dots

* Define the alias in the current shell scope:
    
        alias dots2git='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'

* Checkout the actual content from the bare repository to your `$HOME`:
    
        dots2git checkout

* The step above might fail with a message like:
    
        error: The following untracked working tree files would be overwritten by checkout:
        .bashrc
        .gitignore
    Please move or remove them before you can switch branches.
    Aborting

This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:
```
    mkdir -p .config-backup && 
    dots2git checkout 2>&1 | egrep "s+." | awk {'print $1'} | 
    xargs -I{} mv {} .config-backup/{}
```
* Re-run the check out if you had problems:
    
        dots2git checkout

* Set the flag `showUntrackedFiles` to `no` on this specific (local) repository:
    
        dots2git config --local status.showUntrackedFiles no

* You're done, from now on you can now type `dots2git` commands to add and update your dotfiles:
```
    dots2git status
    dots2git add .vimrc
    dots2git commit -m "Add vimrc"
    dots2git add .bashrc
    dots2git commit -m "Add bashrc"
    dots2git push
```
Again as a shortcut not to have to remember all these steps on any new machine you want to setup, you can create a simple script, [store it as Bitbucket snippet][7] like I did, [create a short url][8] for it and call it like this:
    
    
    curl -Lks http://bit.do/cfg-install | /bin/bash

For completeness this is what I ended up with (tested on many freshly minted [Alpine Linux][9] containers to test it out):
    
    
    git clone --bare https://github.com/bongardino/dotfiles.git $HOME/.dots
    function dots2git {
       /usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME $@
    }
    mkdir -p .config-backup
    dots2git checkout
    if [ $? = 0 ]; then
      echo "Checked out dots.";
      else
        echo "Backing up pre-existing dot files.";
        dots2git checkout 2>&1 | egrep "s+." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi;
    dots2git checkout
    dots2git config status.showUntrackedFiles no

## Wrapping up

## My gitignore file is EXPLICIT to avoid terrible mistakes - make sure to add new files to the whitelist

