#!/bin/bash

git submodule update --init --recursive

mv ~/.vim{,-old}
cp -r .vim ~

mv ~/.bashrc{,-old}
cp .bashrc ~

mv ~/.git-prompt{,-old}
cp .git-prompt ~

mv ~/.inputrc{,-old}
cp .inputrc ~

mv ~/.minttyrc{,-old}
cp .minttyrc ~

mv ~/.vimrc{,-old}
cp .vimrc ~

