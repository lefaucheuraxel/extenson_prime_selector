import GObject from 'gi://GObject';
import St from 'gi://St';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import * as Util from 'resource:///org/gnome/shell/misc/util.js';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import * as QuickSettings from 'resource:///org/gnome/shell/ui/quickSettings.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const GPU_MODES = {
    NVIDIA: 'nvidia',
    INTEL: 'intel',
    HYBRID: 'on-demand'
};

// Toggle pour les Quick Settings
const GPUModeToggle = GObject.registerClass(
class GPUModeToggle extends QuickSettings.QuickMenuToggle {
    _init() {
        super._init({
            title: 'Mode GPU',
            iconName: 'video-display-symbolic',
            toggleMode: false,
        });

        // Menu items pour chaque mode
        this.menu.setHeader('video-display-symbolic', 'Sélection du GPU');
        
        this._nvidiaItem = new PopupMenu.PopupMenuItem('NVIDIA (Performance)');
        this._intelItem = new PopupMenu.PopupMenuItem('Intel (Économie d\'énergie)');
        this._hybridItem = new PopupMenu.PopupMenuItem('Hybrid (On-Demand)');
        
        this.menu.addMenuItem(this._nvidiaItem);
        this.menu.addMenuItem(this._intelItem);
        this.menu.addMenuItem(this._hybridItem);
        
        this._nvidiaItem.connect('activate', () => this._switchGPU(GPU_MODES.NVIDIA));
        this._intelItem.connect('activate', () => this._switchGPU(GPU_MODES.INTEL));
        this._hybridItem.connect('activate', () => this._switchGPU(GPU_MODES.HYBRID));
        
        // Détection du mode actuel
        this._updateCurrentMode();
    }

    _updateCurrentMode() {
        try {
            // Lire le mode actuel depuis prime-select
            let [ok, stdout, stderr] = GLib.spawn_command_line_sync('prime-select query');
            
            if (ok && stdout) {
                let output = new TextDecoder().decode(stdout).trim();
                let mode = output;
                
                // Mettre à jour l'affichage
                this._nvidiaItem.setOrnament(PopupMenu.Ornament.NONE);
                this._intelItem.setOrnament(PopupMenu.Ornament.NONE);
                this._hybridItem.setOrnament(PopupMenu.Ornament.NONE);
                
                switch(mode) {
                    case GPU_MODES.NVIDIA:
                        this.subtitle = 'NVIDIA';
                        this._nvidiaItem.setOrnament(PopupMenu.Ornament.CHECK);
                        break;
                    case GPU_MODES.INTEL:
                        this.subtitle = 'Intel';
                        this._intelItem.setOrnament(PopupMenu.Ornament.CHECK);
                        break;
                    case GPU_MODES.HYBRID:
                        this.subtitle = 'Hybrid';
                        this._hybridItem.setOrnament(PopupMenu.Ornament.CHECK);
                        break;
                    default:
                        this.subtitle = 'Inconnu';
                }
            }
        } catch (e) {
            logError(e, 'Erreur lors de la détection du mode GPU');
            this.subtitle = 'Erreur';
        }
    }

    _switchGPU(mode) {
        try {
            // Créer une notification
            Main.notify('NVIDIA Prime Switcher', 
                `Changement vers le mode ${mode}...`);
            
            // Exécuter pkexec prime-select puis déconnecter immédiatement
            const command = `pkexec prime-select ${mode} && gnome-session-quit --logout`;
            
            Util.spawn(['/bin/bash', '-c', command]);
            
        } catch (e) {
            logError(e, 'Erreur lors du changement de GPU');
            Main.notify('NVIDIA Prime Switcher', 
                'Erreur: Impossible de changer le mode GPU');
        }
    }
});

// Indicateur système pour le panneau Quick Settings
const GPUSystemIndicator = GObject.registerClass(
class GPUSystemIndicator extends QuickSettings.SystemIndicator {
    _init() {
        super._init();
        
        // Créer l'indicateur (invisible dans la barre supérieure)
        this._indicator = this._addIndicator();
        this._indicator.visible = false;
        
        // Créer le toggle et l'associer à l'indicateur
        this.quickSettingsItems.push(new GPUModeToggle());
        
        // Ajouter l'indicateur au panneau
        Main.panel.statusArea.quickSettings.addExternalIndicator(this);
    }
    
    disable() {
        this.quickSettingsItems.forEach(item => item.destroy());
        this._indicator.destroy();
        super.destroy();
    }
});

export default class NvidiaPrimeSwitcherExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        this._indicator = null;
    }

    enable() {
        log('Activation de NVIDIA Prime Switcher');
        
        try {
            // Créer l'indicateur système
            this._indicator = new GPUSystemIndicator();
            
            log('NVIDIA Prime Switcher: Indicateur ajouté avec succès');
        } catch (e) {
            logError(e, 'Erreur lors de l\'activation de NVIDIA Prime Switcher');
        }
    }

    disable() {
        log('Désactivation de NVIDIA Prime Switcher');
        
        if (this._indicator) {
            this._indicator.disable();
            this._indicator = null;
        }
    }
}
