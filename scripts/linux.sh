#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$CONFIG_DIR"

link() {
    local src="$1"
    local dest="$2"

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

# Shell (Bash)
link "$DOTFILES/shell/bashrc" "$HOME/.bashrc"

# Git
link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"

echo "dotfiles symlinked successfully (Linux)"
