#!/bin/bash

git submodule update --init --recursive

mv ~/.vim ~/.vim-old
cp -r .vim ~

mv ~/.bashrc ~/.bashrc-old
cp .bashrc ~

mv ~/.git-prompt ~/.git-prompt-old
cp .git-prompt ~

mv ~/.inputrc ~/.inputrc-old
cp .inputrc ~

mv ~/.minttyrc ~/.minttyrc-old
cp .minttyrc ~

mv ~/.vimrc ~/.vimrc-old
cp .vimrc ~

