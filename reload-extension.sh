#!/bin/bash

# Script pour recharger l'extension après modification

EXTENSION_UUID="nvidia-prime-switcher@axel.local"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Rechargement de l'extension NVIDIA Prime Switcher..."

# Copier les fichiers modifiés
echo "📋 Copie des fichiers..."
cp "$SOURCE_DIR/extension.js" "$EXTENSION_DIR/"
cp "$SOURCE_DIR/metadata.json" "$EXTENSION_DIR/"
cp "$SOURCE_DIR/stylesheet.css" "$EXTENSION_DIR/"

# Désactiver et réactiver l'extension
echo "🔌 Rechargement de l'extension..."
gnome-extensions disable "$EXTENSION_UUID" 2>/dev/null
sleep 1
gnome-extensions enable "$EXTENSION_UUID" 2>/dev/null

echo ""
echo "✅ Extension rechargée!"
echo ""
echo "⚠️  IMPORTANT: Pour que les changements prennent effet, vous devez:"
echo ""

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "  Sur Wayland: Déconnectez-vous et reconnectez-vous"
    echo "  Commande: gnome-session-quit --logout"
else
    echo "  Sur X11: Redémarrer GNOME Shell"
    echo "  Appuyez sur Alt+F2, tapez 'r', puis Entrée"
fi

echo ""
echo "Voulez-vous vous déconnecter maintenant? (o/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    gnome-session-quit --logout
fi
