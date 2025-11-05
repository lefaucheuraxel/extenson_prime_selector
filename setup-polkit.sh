#!/bin/bash

# Script pour configurer polkit et permettre prime-select sans mot de passe

echo "=========================================="
echo "Configuration de polkit pour prime-select"
echo "=========================================="
echo ""

POLKIT_FILE="/etc/polkit-1/localauthority/50-local.d/prime-select-no-password.pkla"

echo "Création de la règle polkit..."
echo ""

# Créer le fichier polkit
sudo tee "$POLKIT_FILE" > /dev/null <<'EOF'
[Allow prime-select without password]
Identity=unix-user:*
Action=org.freedesktop.policykit.exec
ResultActive=yes
ResultInactive=no
ResultAny=no
EOF

if [ $? -eq 0 ]; then
    echo "✅ Règle polkit créée avec succès dans:"
    echo "   $POLKIT_FILE"
    echo ""
    echo "⚠️  IMPORTANT: Vous devez redémarrer votre session pour que"
    echo "   les changements prennent effet."
    echo ""
    echo "Après le redémarrage, prime-select ne demandera plus de mot de passe."
else
    echo "❌ Erreur lors de la création de la règle polkit"
    exit 1
fi

echo ""
echo "Voulez-vous vous déconnecter maintenant? (o/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    gnome-session-quit --logout
fi
