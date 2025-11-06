#!/bin/bash

# Script de désinstallation pour NVIDIA Prime Switcher

set -e

EXTENSION_UUID="nvidia-prime-switcher@axel.local"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"

echo "==================================="
echo "NVIDIA Prime Switcher - Désinstallation"
echo "==================================="
echo ""

# Désactiver l'extension
echo "🔌 Désactivation de l'extension..."
gnome-extensions disable "$EXTENSION_UUID" 2>/dev/null || true

# Supprimer le dossier
if [ -d "$EXTENSION_DIR" ]; then
    echo "🗑️  Suppression des fichiers..."
    rm -rf "$EXTENSION_DIR"
    echo "✅ Extension supprimée"
else
    echo "⚠️  L'extension n'est pas installée"
fi

echo ""
echo "==================================="
echo "✅ Désinstallation terminée!"
echo "==================================="
echo ""

# Proposer de supprimer la règle polkit
POLKIT_FILE="/usr/share/polkit-1/actions/com.nvidia.prime.policy"
if [ -f "$POLKIT_FILE" ]; then
    read -p "Voulez-vous supprimer la règle polkit? (o/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Oo]$ ]]; then
        sudo rm "$POLKIT_FILE"
        echo "✅ Règle polkit supprimée"
    fi
fi

echo ""
echo "Pour appliquer les changements, redémarrez GNOME Shell:"
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "  Sur Wayland: Déconnectez-vous et reconnectez-vous"
else
    echo "  Sur X11: Alt+F2, tapez 'r', puis Entrée"
fi
echo ""
