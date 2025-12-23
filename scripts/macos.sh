#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

link() {
    src="$1"
    dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        rm -rf "$dest"
    fi

    ln -s "$src" "$dest"
    echo "linked $dest → $src"
}

# Neovim
link "$DOTFILES/nvim" "$CONFIG_DIR/nvim"

# Yazi
link "$DOTFILES/yazi" "$CONFIG_DIR/yazi"

# Oh My Posh
link "$DOTFILES/ohmyposh" "$CONFIG_DIR/ohmyposh"

# Shell
link "$DOTFILES/shell/zshrc" "$HOME/.zshrc"

# Git
link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

echo "dotfiles symlinked successfully (Mac Os)"
