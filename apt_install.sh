#!/usr/bin/env bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo updating and upgrading
sleep 5
sudo apt-get update && sudo apt-get upgrade -y

echo installing the must-have pre-requisites
while read -r p; do sudo apt-get install -y "$p"; done < <(
	cat <<"EOF"
    automake cmake
    cargo
    clang
    curl
    fish
    fzf
    jq
    lazygit
    perl
    python3 python3-pip
    ranger
    ripgrep
    software-properties-common
    tmux
    wget
    xsel
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

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim -y
cargo install exa

git clone --recurse-submodules https://github.com/WinTush/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
./install
