#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Setting up dotfiles from $DOTFILES_DIR"

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            echo "✓ $target already linked correctly"
            return
        fi
        echo "Backing up existing $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    ln -s "$source" "$target"
    echo "✓ Linked $source -> $target"
}

# Link config files
if [ -d "$DOTFILES_DIR/config" ]; then
    for item in "$DOTFILES_DIR/config"/*; do
        if [ -e "$item" ]; then
            basename_item="$(basename "$item")"
            create_symlink "$item" "$CONFIG_DIR/$basename_item"
        fi
    done
fi

# Link dotfiles in home directory (if any exist)
for dotfile in "$DOTFILES_DIR"/.??*; do
    if [ -f "$dotfile" ]; then
        basename_dotfile="$(basename "$dotfile")"
        create_symlink "$dotfile" "$HOME/$basename_dotfile"
    fi
done

echo "Dotfiles installation complete!"