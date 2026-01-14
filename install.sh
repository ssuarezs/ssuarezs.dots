#!/bin/bash

# Detectar Sistema Operativo
OS="$(uname -s)"
echo "🖥️  Sistema detectado: $OS"

# Colores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# --- 1. Instalar Homebrew (Cross-platform logic) ---
if ! command -v brew &>/dev/null; then
  echo -e "${BLUE}🍺 Instalando Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Configurar PATH dinámicamente según OS
  if [ "$OS" = "Darwin" ]; then
    # macOS Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ "$OS" = "Linux" ]; then
    # Linux estándar
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
else
  echo -e "${GREEN}✅ Homebrew ya está instalado.${NC}"
fi

# --- 2. Brew Bundle ---
echo -e "${BLUE}📦 Instalando paquetes...${NC}"
brew bundle --file=./homebrew/Brewfile

# --- 3. Oh My Zsh & Stow (Igual que antes) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  rm -f ~/.zshrc
fi

echo -e "${BLUE}🔗 Ejecutando Stow...${NC}"
mkdir -p ~/.config/alacritty ~/.config/ohmyposh
stow --restow zsh nvim alacritty tmux git wezterm

# --- 4. Configurar Shell (Rutas Dinámicas) ---
# Obtener la ruta real de zsh instalado por brew
BREW_ZSH="$(brew --prefix)/bin/zsh"

if ! grep -Fxq "$BREW_ZSH" /etc/shells; then
  echo -e "${BLUE}🔒 Agregando Zsh a /etc/shells...${NC}"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$BREW_ZSH" ]; then
  chsh -s "$BREW_ZSH"
fi

# --- 5. Runtimes ---
fnm install --lts
uv python install

if command -v bun &>/dev/null; then
  bun completions >/dev/null 2>&1
fi

# --- 6. Pasos Específicos por OS ---
if [ "$OS" = "Darwin" ]; then
  # Solo ejecutar defaults en Mac
  if [ -f "./macos/defaults.sh" ]; then
    echo -e "${BLUE}🍎 Aplicando defaults de macOS...${NC}"
    source ./macos/defaults.sh
  fi

  # Instalar TPM (Tmux Plugin Manager)
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

elif [ "$OS" = "Linux" ]; then
  echo -e "${BLUE}🐧 Configuración Linux...${NC}"
  echo "⚠️  Nota: En Linux debes instalar Alacritty y las Fuentes manualmente o con apt/pacman, ya que Brew Cask no existe aquí."

  # También instalamos TPM en Linux
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
fi

echo -e "${GREEN}✨ ¡Instalación Finalizada!${NC}"
