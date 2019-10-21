#!/bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

git submodule update --init --recursive

mv ~/.vim ~/.vim-old
cp -r .vim ~

cat .bashrc >> ~/.bashrc
cat .bashrc >> ~/.zshrc

mv ~/.vimrc ~/.vimrc-old
cp .vimrc ~

cat .gitconfig >> ~/.gitconfig
