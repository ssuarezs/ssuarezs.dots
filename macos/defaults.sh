#!/bin/bash

# Cerrar Preferencias del Sistema para evitar conflictos
osascript -e 'tell application "System Preferences" to quit'

# --- Teclado (CRÍTICO para VIM/NEOVIM) ---
# KeyRepeat: Qué tan rápido se repite la tecla (2 = muy rápido, normal es 6)
defaults write NSGlobalDomain KeyRepeat -int 2
# InitialKeyRepeat: Cuánto tarda en empezar a repetir (15 = 225ms)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# --- Finder ---
# Mostrar extensiones de archivo siempre
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Mostrar barra de ruta (path bar)
defaults write com.apple.finder ShowPathbar -bool true

# --- Dock ---
# Ocultar automáticamente
defaults write com.apple.dock autohide -bool true
# No mostrar aplicaciones recientes en el Dock
defaults write com.apple.dock show-recents -bool false
# Hacerlo más pequeño
defaults write com.apple.dock tilesize -int 46

# Reiniciar servicios afectados
killall Finder
killall Dock
