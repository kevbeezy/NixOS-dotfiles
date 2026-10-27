#!/usr/bin/env bash
MODULE=$1
TOGGLE_FILE="$HOME/.nixos-toggles.json"
FLAKE_DIR="$HOME/.dotfiles"
if [ -z "$MODULE" ]; then
    echo "Usage: toggle-module <tools|arduino|game|mango|plasma>"
    exit 1
fi
if [ ! -f "$TOGGLE_FILE" ]; then
    echo '{"tools":true,"arduino":false,"game":false,"mango":true,"plasma":false,"nvidia":false}' > "$TOGGLE_FILE"
fi
jq ".$MODULE = (.$MODULE | not)" "$TOGGLE_FILE" > "${TOGGLE_FILE}.tmp" && mv "${TOGGLE_FILE}.tmp" "$TOGGLE_FILE"
echo "Toggled $MODULE. Rebuilding NixOS..."
sudo nixos-rebuild switch --flake "$FLAKE_DIR#joachim" --impure
