#!/usr/bin/env bash
set -euo pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

OS="$(uname -s)"

echo "Detected OS: $OS"

install_macos() {
    if ! command_exists brew; then
        echo "Homebrew not found. Installing Homebrew."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew update

    brew install \
        neovim \
        yazi \
        oh-my-posh \
        fd \
        ripgrep \
        viu \
        jq \
        fzf

    # Nerd Font (Meslo)
    brew tap homebrew/cask-fonts
    brew install --cask font-meslo-lg-nerd-font

    # fzf extras
    "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
}

install_linux() {
    if ! command_exists apt; then
        echo "Only apt-based distros are supported."
        exit 1
    fi

    sudo apt update

    sudo apt install -y \
        neovim \
        fd-find \
        ripgrep \
        jq \
        fzf

    # fd binary name fix
    if ! command_exists fd && command_exists fdfind; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    fi

    # yazi
    if ! command_exists yazi; then
        curl -fsSL https://yazi-rs.github.io/install.sh | bash
    fi

    # oh-my-posh
    if ! command_exists oh-my-posh; then
        curl -fsSL https://ohmyposh.dev/install.sh | bash
    fi

    # viu
    if ! command_exists viu; then
        cargo install viu
    fi

    # Nerd Font (Meslo)
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/L/Regular/MesloLGS%20NF%20Regular.ttf
    fc-cache -fv
}

case "$OS" in
Darwin)
    install_macos
    ;;
Linux)
    install_linux
    ;;
*)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "All requirements installed successfully."
