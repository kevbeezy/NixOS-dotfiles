#!/usr/bin/env bash
TOGGLE_FILE="$HOME/.nixos-toggles.json"
if [ -f "$TOGGLE_FILE" ]; then
    echo "Toggle file already exists at $TOGGLE_FILE. Skipping."
    exit 0
fi
echo "Generating default toggle state at $TOGGLE_FILE..."
cat <<EOF > "$TOGGLE_FILE"
{
  "nvidia": false,
  "game": false,
  "mango": true,
  "plasma": false,
  "arduino": false,
  "tools": true
}
EOF
echo "Done!"
