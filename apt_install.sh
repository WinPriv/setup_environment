#!/usr/bin/env bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo updating and upgrading
sleep 5
sudo apt-get update && sudo apt-get upgrade -y

echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    cargo
    clang
    curl
    fish
    jq
    perl
    software-properties-common
    wget
    zip unzip
EOF
)

echo installing the nice-to-have pre-requisites
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

# sudo apt-get install -y tig

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim -y
cargo install exa

git clone https://github.com/WinTush/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
./install

rm -f ~/.config/nvim
git clone https://github.com/LunarVim/Neovim-from-scratch.git ~/.config/nvim
nvim +PackerSync
