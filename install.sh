#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to
# any desired dotfiles in ~/dotfiles
############################

########## Variables
dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc i3blocks.conf vimrc zshrc xinitrc Xmodmap Xresources zshrc compton.conf"    # list of files/folders to symlink in homedir
files_config="i3 termite"
##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
	    echo "Moving any existing dotfiles from ~ to $olddir"
	        mv ~/.$file ~/dotfiles_old/
		    echo "Creating symlink to $file in home directory."
		        ln -s $dir/$file ~/.$file
		done
for file_config in $files_config; do
  mkdir -p ~/.config/$file_config
  ln -s $dir/$file_config ~/.config/$file_config/config
done
