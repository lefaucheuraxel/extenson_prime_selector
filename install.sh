#!/bin/bash

# Script d'installation pour NVIDIA Prime Switcher
# Extension GNOME Shell pour Ubuntu 25.10

set -e

EXTENSION_UUID="nvidia-prime-switcher@axel.local"
EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_UUID"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==================================="
echo "NVIDIA Prime Switcher - Installation"
echo "==================================="
echo ""

# Vérifier que prime-select est installé
if ! command -v prime-select &> /dev/null; then
    echo "❌ Erreur: prime-select n'est pas installé"
    echo "   Installez-le avec: sudo apt install nvidia-prime"
    exit 1
fi

echo "✅ prime-select détecté"

# Vérifier la version de GNOME Shell
GNOME_VERSION=$(gnome-shell --version | grep -oP '\d+' | head -1)
echo "✅ GNOME Shell version: $GNOME_VERSION"

if [ "$GNOME_VERSION" -lt 46 ]; then
    echo "⚠️  Attention: Cette extension est conçue pour GNOME Shell 46+"
    echo "   Votre version est $GNOME_VERSION"
    read -p "   Continuer quand même? (o/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Oo]$ ]]; then
        exit 1
    fi
fi

# Créer le dossier de destination
echo "📁 Création du dossier d'extension..."
mkdir -p "$EXTENSION_DIR"

# Compiler les schémas
echo "🔧 Compilation des schémas GSettings..."
if [ -d "$SOURCE_DIR/schemas" ]; then
    glib-compile-schemas "$SOURCE_DIR/schemas/"
fi

# Copier les fichiers
echo "📋 Copie des fichiers..."
cp -r "$SOURCE_DIR"/* "$EXTENSION_DIR/"

# Vérifier que les fichiers essentiels sont présents
if [ ! -f "$EXTENSION_DIR/metadata.json" ] || [ ! -f "$EXTENSION_DIR/extension.js" ]; then
    echo "❌ Erreur: Fichiers essentiels manquants"
    exit 1
fi

echo "✅ Fichiers copiés avec succès"

# Activer l'extension
echo "🔌 Activation de l'extension..."
gnome-extensions enable "$EXTENSION_UUID" 2>/dev/null || true

echo ""
echo "==================================="
echo "✅ Installation terminée!"
echo "==================================="
echo ""
echo "Pour appliquer les changements:"
echo ""

# Détecter si on est sur X11 ou Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "  Sur Wayland: Déconnectez-vous et reconnectez-vous"
    echo "  Ou utilisez: gnome-session-quit --logout"
else
    echo "  Sur X11: Appuyez sur Alt+F2, tapez 'r', puis Entrée"
fi

echo ""
echo "Ensuite, cherchez 'Mode GPU' dans le panneau de raccourcis système"
echo ""
echo "⚠️  Important: Pour éviter de saisir le mot de passe à chaque fois,"
echo "   consultez la section 'Configuration de pkexec' dans le README.md"
echo ""

# Proposer de configurer polkit
read -p "Voulez-vous configurer polkit maintenant? (o/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    echo ""
    echo "Création de la règle polkit..."
    
    POLKIT_FILE="/usr/share/polkit-1/actions/com.nvidia.prime.policy"
    
    sudo tee "$POLKIT_FILE" > /dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
  <action id="com.nvidia.prime.select">
    <description>Change NVIDIA Prime GPU mode</description>
    <message>Authentification requise pour changer le mode GPU</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>yes</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/prime-select</annotate>
  </action>
</policyconfig>
EOF
    
    echo "✅ Règle polkit créée avec succès"
fi

echo ""
echo "Installation terminée! 🎉"
