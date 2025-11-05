# Guide d'installation - NVIDIA Prime Switcher

## Installation rapide

### Méthode 1 : Script automatique (Recommandé)

```bash
cd /home/axel/Documents/nvidia-prime-switcher
./install.sh
```

Le script va :
- ✅ Vérifier les prérequis
- ✅ Compiler les schémas
- ✅ Copier l'extension
- ✅ Activer l'extension
- ✅ (Optionnel) Configurer polkit

### Méthode 2 : Installation manuelle

```bash
# 1. Compiler les schémas
cd /home/axel/Documents/nvidia-prime-switcher
glib-compile-schemas schemas/

# 2. Copier l'extension
mkdir -p ~/.local/share/gnome-shell/extensions/nvidia-prime-switcher@axel.local
cp -r * ~/.local/share/gnome-shell/extensions/nvidia-prime-switcher@axel.local/

# 3. Activer l'extension
gnome-extensions enable nvidia-prime-switcher@axel.local

# 4. Redémarrer GNOME Shell
# Sur X11: Alt+F2, tapez 'r', puis Entrée
# Sur Wayland: Déconnectez-vous et reconnectez-vous
```

## Configuration post-installation

### Éviter de saisir le mot de passe à chaque changement

Créez une règle polkit pour autoriser le changement de GPU sans mot de passe :

```bash
sudo nano /usr/share/polkit-1/actions/com.nvidia.prime.policy
```

Collez ce contenu :

```xml
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
```

Sauvegardez (Ctrl+O, Entrée, Ctrl+X).

## Utilisation

1. **Ouvrir le panneau système** : Cliquez en haut à droite de votre écran
2. **Trouver "Mode GPU"** : Cherchez l'icône avec le titre "Mode GPU"
3. **Sélectionner un mode** :
   - 🎮 **NVIDIA (Performance)** : Pour les jeux et applications 3D
   - 💚 **Intel (Économie d'énergie)** : Pour économiser la batterie
   - ⚡ **Hybrid (On-Demand)** : Basculement automatique

4. **Redémarrer la session** : Après le changement, redémarrez votre session pour appliquer

## Vérification

Pour vérifier que l'extension fonctionne :

```bash
# Vérifier que l'extension est activée
gnome-extensions list | grep nvidia-prime

# Vérifier le mode GPU actuel
prime-select query

# Voir les logs de l'extension
journalctl -f -o cat /usr/bin/gnome-shell | grep -i nvidia
```

## Désinstallation

```bash
cd /home/axel/Documents/nvidia-prime-switcher
./uninstall.sh
```

Ou manuellement :

```bash
gnome-extensions disable nvidia-prime-switcher@axel.local
rm -rf ~/.local/share/gnome-shell/extensions/nvidia-prime-switcher@axel.local
```

## Problèmes courants

### L'extension n'apparaît pas dans le panneau

**Solution** :
```bash
# Redémarrer GNOME Shell
# X11: Alt+F2, tapez 'r'
# Wayland: Déconnectez-vous et reconnectez-vous

# Vérifier les erreurs
journalctl -f -o cat /usr/bin/gnome-shell
```

### "prime-select: command not found"

**Solution** :
```bash
sudo apt update
sudo apt install nvidia-prime
```

### Le changement de GPU ne s'applique pas

**Solution** :
- Assurez-vous de redémarrer votre session (pas seulement GNOME Shell)
- Vérifiez que les pilotes NVIDIA sont correctement installés :
  ```bash
  nvidia-smi
  ```

### Erreur "Authentication required"

**Solution** :
- Configurez polkit comme indiqué dans la section "Configuration post-installation"
- Ou entrez votre mot de passe quand demandé

## Support

Pour toute question ou problème :
1. Consultez le README.md
2. Vérifiez les logs : `journalctl -f -o cat /usr/bin/gnome-shell`
3. Testez manuellement : `sudo prime-select nvidia`

## Compatibilité testée

- ✅ Ubuntu 25.10 (GNOME 47)
- ✅ Ubuntu 24.04 LTS (GNOME 46)
- ⚠️ Autres versions : Peut nécessiter des ajustements

## Licence

MIT - Libre d'utilisation et de modification
