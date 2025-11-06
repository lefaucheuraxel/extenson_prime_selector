# NVIDIA Prime Switcher - Extension GNOME Shell

Extension pour Ubuntu 25.10 et Gnome 48 permettant de basculer facilement entre les modes GPU NVIDIA Prime directement depuis le panneau de raccourcis système.

## Fonctionnalités

- 🎮 **Mode NVIDIA** : Performance maximale avec le GPU dédié NVIDIA
- 💚 **Mode Intel** : Économie d'énergie avec le GPU intégré Intel ou Amd
- ⚡ **Mode Hybrid (On-Demand)** : Basculement automatique selon les besoins

## Prérequis

- Ubuntu 25.10 (ou distribution avec GNOME Shell 48)
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

## Installation

```bash
#Rendez-vous dans le dossier télécharger
cd home/Utilisateur/Téléchargements/extension_prime_selector

#Donner les droits
chmod +x install.sh

#executer
./install.sh 
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
6. Redémarrez votre session pour appliquer les changements (la page met quelque seconde a s'afficher)

## Désinstallation

```bash
#Rendez-vous dans le dossier télécharger
cd home/Utilisateur/Téléchargements/extension_prime_selector

#Donner les droits
chmod +x uninstall.sh

#executer
./uninstall.sh 
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
