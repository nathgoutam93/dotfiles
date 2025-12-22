#!/usr/bin/env bash
set -euo pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

OS="$(uname -s)"
echo "Detected OS: $OS"

install_macos() {
    # curl is required to install brew
    if ! command_exists curl; then
        echo "curl is required but not installed. Install curl first."
        exit 1
    fi

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
        fzf \
        unzip \
        fontconfig

    # Nerd Font (Meslo)
    brew tap homebrew/cask-fonts
    brew install --cask font-meslo-lg-nerd-font

    # fzf extras
    "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
}

install_neovim_linux() {
    if command -v nvim >/dev/null 2>&1; then
        return
    fi

    tmpdir=$(mktemp -d)

    command curl -fL \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage \
        -o "$tmpdir/nvim.appimage"

    chmod +x "$tmpdir/nvim.appimage"
    sudo install "$tmpdir/nvim.appimage" /usr/local/bin/nvim
    rm -rf "$tmpdir"
}

install_linux() {
    if ! command_exists apt; then
        echo "Only apt-based distros are supported."
        exit 1
    fi

    sudo apt update

    sudo apt install -y \
        curl \
        unzip \
        fontconfig \
        fd-find \
        ripgrep \
        jq \
        fzf

    install_neovim_linux

    # fd binary name fix
    if ! command_exists fd && command_exists fdfind; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    fi

    # yazi + ya
    if ! command_exists yazi || ! command_exists ya; then
        tmpdir=$(mktemp -d)

        curl -L https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip \
            -o "$tmpdir/yazi.zip"

        unzip -q "$tmpdir/yazi.zip" -d "$tmpdir"

        for bin in yazi ya; do
            bin_path=$(find "$tmpdir" -type f -name "$bin" -perm -u+x | head -n 1)
            if [ -z "$bin_path" ]; then
                echo "$bin binary not found"
                exit 1
            fi
            sudo install "$bin_path" /usr/local/bin/"$bin"
        done

        rm -rf "$tmpdir"
    fi

    # oh-my-posh
    if ! command_exists oh-my-posh; then
        curl -fsSL https://ohmyposh.dev/install.sh | bash
    fi

    # viu
    if ! command_exists viu; then
        tmpdir=$(mktemp -d)
        curl -L https://github.com/atanunq/viu/releases/latest/download/viu-x86_64-unknown-linux-musl \
            -o "$tmpdir/viu"
        sudo install "$tmpdir/viu" /usr/local/bin/viu
        rm -rf "$tmpdir"
    fi

    # Nerd Font (Meslo)
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    curl -fLo "$FONT_DIR/MesloLGSNF-Regular.ttf" \
        https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Meslo/L/Regular/MesloLGLNerdFontMono-Regular.ttf
    fc-cache -fv
}

case "$OS" in
Darwin) install_macos ;;
Linux) install_linux ;;
*)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "All requirements installed successfully."
