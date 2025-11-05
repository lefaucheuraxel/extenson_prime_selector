# NVIDIA Prime Switcher - Extension GNOME Shell

Extension pour Ubuntu 25.10 permettant de basculer facilement entre les modes GPU NVIDIA Prime directement depuis le panneau de raccourcis système.

## Fonctionnalités

- 🎮 **Mode NVIDIA** : Performance maximale avec le GPU dédié NVIDIA
- 💚 **Mode Intel** : Économie d'énergie avec le GPU intégré Intel
- ⚡ **Mode Hybrid (On-Demand)** : Basculement automatique selon les besoins

## Prérequis

- Ubuntu 25.10 (ou distribution avec GNOME Shell 46/47)
- NVIDIA Prime installé (`nvidia-prime` package)
- Pilotes NVIDIA propriétaires installés

## Installation

### 1. Vérifier les prérequis

```bash
# Vérifier que NVIDIA Prime est installé
which prime-select

# Vérifier le mode actuel
prime-select query
```

### 2. Installer l'extension

```bash
# Aller dans le dossier de l'extension
cd /home/axel/Documents/nvidia-prime-switcher

# Compiler les schémas GSettings
glib-compile-schemas schemas/

# Copier l'extension dans le dossier des extensions GNOME
mkdir -p ~/.local/share/gnome-shell/extensions/nvidia-prime-switcher@axel.local
cp -r * ~/.local/share/gnome-shell/extensions/nvidia-prime-switcher@axel.local/

# Redémarrer GNOME Shell
# Sur X11: Alt+F2, tapez 'r', puis Entrée
# Sur Wayland: Déconnectez-vous et reconnectez-vous
```

### 3. Activer l'extension

```bash
# Activer l'extension via la ligne de commande
gnome-extensions enable nvidia-prime-switcher@axel.local

# Ou utilisez l'application "Extensions" (gnome-extensions-app)
```

### 4. Configuration de pkexec (Important!)

Pour permettre le changement de GPU sans mot de passe à chaque fois, créez une règle polkit :

```bash
sudo nano /etc/polkit-1/localauthority/50-local.d/prime-select.pkla
```

Ajoutez le contenu suivant :

```ini
[Allow prime-select for users]
Identity=unix-user:*
Action=org.freedesktop.policykit.exec
ResultActive=yes
ResultInactive=no
ResultAny=no
```

Ou pour plus de sécurité, créez un fichier spécifique :

```bash
sudo nano /usr/share/polkit-1/actions/com.nvidia.prime.policy
```

Avec le contenu :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
  <action id="com.nvidia.prime.select">
    <description>Change NVIDIA Prime GPU mode</description>
    <message>Authentication is required to change GPU mode</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>yes</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/prime-select</annotate>
  </action>
</policyconfig>
```

## Utilisation

1. Cliquez sur le panneau de raccourcis système (en haut à droite)
2. Cherchez l'icône "Mode GPU"
3. Cliquez dessus pour voir les options disponibles
4. Sélectionnez le mode souhaité :
   - **NVIDIA** : Pour les jeux et applications gourmandes
   - **Intel** : Pour économiser la batterie
   - **Hybrid** : Laisse le système choisir automatiquement

5. Entrez votre mot de passe si demandé
6. Redémarrez votre session pour appliquer les changements

## Désinstallation

```bash
# Désactiver l'extension
gnome-extensions disable nvidia-prime-switcher@axel.local

# Supprimer l'extension
rm -rf ~/.local/share/gnome-shell/extensions/nvidia-prime-switcher@axel.local
```

## Dépannage

### L'extension n'apparaît pas

```bash
# Vérifier que l'extension est installée
gnome-extensions list

# Voir les logs
journalctl -f -o cat /usr/bin/gnome-shell

# Vérifier la version de GNOME Shell
gnome-shell --version
```

### Erreur "prime-select not found"

```bash
# Installer NVIDIA Prime
sudo apt update
sudo apt install nvidia-prime
```

### Le changement de GPU ne fonctionne pas

```bash
# Vérifier manuellement
sudo prime-select query
sudo prime-select nvidia
sudo prime-select intel
sudo prime-select on-demand
```

## Compatibilité

- ✅ Ubuntu 25.10
- ✅ Ubuntu 24.04 LTS (avec GNOME 46)
- ✅ Fedora 40+ (avec GNOME 46+)
- ✅ Autres distributions avec GNOME Shell 46 ou 47

## Licence

MIT License - Libre d'utilisation et de modification

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir des issues ou des pull requests.

## Auteur

Créé pour faciliter la gestion de NVIDIA Prime sur Ubuntu 25.10
