#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

symlink() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ]; then
        echo "  already linked: $dst"
        return
    fi

    if [ -e "$dst" ]; then
        echo "  backing up: $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  linked: $dst"
}

echo "Installing dotfiles from $DOTFILES"
echo

echo "[niri]"
symlink "$DOTFILES/.config/niri" "$CONFIG/niri"

echo "[ghostty]"
symlink "$DOTFILES/.config/ghostty" "$CONFIG/ghostty"

echo "[nvim]"
symlink "$DOTFILES/.config/nvim" "$CONFIG/nvim"

echo "[keyd]"
if command -v keyd &>/dev/null; then
    echo "  symlinking keyd configs to /etc/keyd/ (needs sudo)"
    sudo ln -sf "$DOTFILES/keyd/default.conf" /etc/keyd/default.conf
    sudo ln -sf "$DOTFILES/keyd/app.conf" /etc/keyd/app.conf
    sudo systemctl restart keyd
    symlink "$DOTFILES/.config/keyd/app.conf" "$CONFIG/keyd/app.conf"
fi

echo "[fish]"
symlink "$DOTFILES/.config/fish/config.fish" "$CONFIG/fish/config.fish"
symlink "$DOTFILES/.config/fish/conf.d" "$CONFIG/fish/conf.d"
symlink "$DOTFILES/.config/fish/functions" "$CONFIG/fish/functions"
symlink "$DOTFILES/.config/fish/completions" "$CONFIG/fish/completions"

echo
echo "Done. Reload your shell or restart apps to apply changes."
