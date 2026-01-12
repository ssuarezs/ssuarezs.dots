#!/bin/bash

# Definir colores para los logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando Setup de Entorno de Desarrollo...${NC}"

# --- 1. Instalar Homebrew ---
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}🍺 Instalando Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Agregar al path para la sesión actual (Apple Silicon)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✅ Homebrew ya está instalado.${NC}"
fi

# --- 2. Instalar Paquetes (Brewfile) ---
echo -e "${BLUE}📦 Instalando paquetes desde Brewfile...${NC}"
brew bundle --file=./homebrew/Brewfile

# --- 3. Instalar Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}⚡ Instalando Oh My Zsh...${NC}"
    # --unattended evita que el script se detenga pidiendo confirmación
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # BORRAR el .zshrc que crea el instalador automáticamente
    # para que no choque con el nuestro al usar Stow
    rm -f ~/.zshrc
else
    echo -e "${GREEN}✅ Oh My Zsh ya está instalado.${NC}"
fi

# --- 4. GNU Stow (Enlazar Dotfiles) ---
echo -e "${BLUE}🔗 Enlazando configuraciones con Stow...${NC}"

# Crear carpetas base necesarias si no existen
mkdir -p ~/.config
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/ohmyposh

# Ejecutar Stow para cada paquete
# --restow: actualiza enlaces si ya existen
stow --restow zsh
stow --restow nvim
stow --restow alacritty
stow --restow tmux
stow --restow git

# --- 5. Configurar Shell por defecto (Zsh de Brew) ---
BREW_ZSH="$(brew --prefix)/bin/zsh"

if grep -Fxq "$BREW_ZSH" /etc/shells; then
    echo -e "${GREEN}✅ Zsh de Homebrew ya está en /etc/shells${NC}"
else
    echo -e "${BLUE}🔒 Agregando Zsh de Homebrew a /etc/shells (requiere sudo)...${NC}"
    echo "$BREW_ZSH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$BREW_ZSH" ]; then
    echo -e "${BLUE}🔄 Cambiando Shell por defecto a Zsh de Homebrew...${NC}"
    chsh -s "$BREW_ZSH"
fi

# --- 6. Configurar Runtimes ---
echo -e "${BLUE}🐍 Inicializando Python y Node...${NC}"
# Instalar Node LTS
fnm install --lts
# Instalar Python estable
uv python install

# --- 7. Configuración de macOS ---
if [ -f "./macos/defaults.sh" ]; then
    echo -e "${BLUE}🍎 Aplicando configuraciones de macOS...${NC}"
    source ./macos/defaults.sh
fi

echo -e "${GREEN}✨ ¡Instalación completada con éxito! Reinicia tu terminal o cierra sesión.${NC}"