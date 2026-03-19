#!/bin/bash

# Close System Preferences to avoid conflicts
osascript -e 'tell application "System Preferences" to quit'

# --- Keyboard (CRITICAL for VIM/NEOVIM) ---
# KeyRepeat: How fast the key repeats (2 = very fast, default is 6)
defaults write NSGlobalDomain KeyRepeat -int 2
# InitialKeyRepeat: How long until it starts repeating (15 = 225ms)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# --- Finder ---
# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# --- Dock ---
# Automatically hide
defaults write com.apple.dock autohide -bool true
# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
# Make it smaller
defaults write com.apple.dock tilesize -int 46

# Restart affected services
killall Finder
killall Dock
