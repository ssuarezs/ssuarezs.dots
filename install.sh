#!/bin/bash

echo "🚀 Iniciando instalación de Dotfiles..."

# 1. Instalar Homebrew si no existe
if ! command -v brew &> /dev/null; then
    echo "🍺 Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Agregar Homebrew al path temporalmente para esta sesión
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Instalar paquetes desde el Brewfile
echo "📦 Instalando aplicaciones desde Brewfile..."
brew bundle --file=./homebrew/Brewfile

# 3. Preparar directorios necesarios
# Stow no puede crear carpetas padre, así que aseguramos que existan
mkdir -p ~/.config

# 4. Usar GNU Stow para crear enlaces simbólicos
echo "🔗 Enlazando configuraciones con Stow..."
# --restow permite re-ejecutar el script sin errores si ya existen los links
stow --restow zsh
stow --restow nvim
stow --restow alacritty
stow --restow tmux
stow --restow git

# 5. Configurar macOS (Teclado rápido, etc)
echo "🍎 Aplicando configuraciones de macOS..."
source ./macos/defaults.sh

# 6. Inicializar Runtimes
echo "🐍 Configurando Python y Node..."
# Instalar python estable y node lts
uv python install
fnm install --lts

echo "✅ ¡Instalación completada! Reinicia tu terminal."