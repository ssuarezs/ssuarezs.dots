#!/bin/bash

# Detect Operating System
OS="$(uname -s)"
echo "🖥️  Detected system: $OS"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# --- 1. Install Homebrew (Cross-platform logic) ---
if ! command -v brew &>/dev/null; then
  echo -e "${BLUE}🍺 Installing Homebrew...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Configure PATH dynamically based on OS
  if [ "$OS" = "Darwin" ]; then
    # macOS Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ "$OS" = "Linux" ]; then
    # Standard Linux
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
else
  echo -e "${GREEN}✅ Homebrew is already installed.${NC}"
fi

# --- 2. Brew Bundle ---
echo -e "${BLUE}📦 Installing packages...${NC}"
brew bundle --file=./homebrew/Brewfile

# --- 3. Oh My Zsh & Stow (Same as before) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  rm -f ~/.zshrc
fi

echo -e "${BLUE}🔗 Running Stow...${NC}"
mkdir -p ~/.config/alacritty ~/.config/ohmyposh
stow --restow zsh nvim alacritty tmux git wezterm ghostty

# --- 4. Configure Shell (Dynamic Paths) ---
# Get the real path of zsh installed by brew
BREW_ZSH="$(brew --prefix)/bin/zsh"

if ! grep -Fxq "$BREW_ZSH" /etc/shells; then
  echo -e "${BLUE}🔒 Adding Zsh to /etc/shells...${NC}"
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

# --- 6. OS-Specific Steps ---
if [ "$OS" = "Darwin" ]; then
  # Only run defaults on Mac
  if [ -f "./macos/defaults.sh" ]; then
    echo -e "${BLUE}🍎 Applying macOS defaults...${NC}"
    source ./macos/defaults.sh
  fi

  # Setup macOS key mappings
  setup_macos_keys

elif [ "$OS" = "Linux" ]; then
  echo -e "${BLUE}🐧 Linux configuration...${NC}"
  echo "⚠️  Note: On Linux you must install Alacritty and Fonts manually or with apt/pacman, since Brew Cask doesn't exist here."
fi

# Install TPM (Tmux Plugin Manager) - Common for both OS
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

setup_macos_keys() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "Configuring Caps Lock -> Control mapping from repo files..."

    local PLIST_NAME="com.user.capslocktocontrol.plist"
    local TARGET_DIR="$HOME/Library/LaunchAgents"
    local SOURCE_PATH="macos/$PLIST_NAME"

    mkdir -p "$TARGET_DIR"

    if [ -f "$SOURCE_PATH" ]; then
      cp "$SOURCE_PATH" "$TARGET_DIR/$PLIST_NAME"
      chmod 644 "$TARGET_DIR/$PLIST_NAME"
    else
      echo "Error: $SOURCE_PATH not found"
      return 1
    fi

    launchctl bootout gui/$(id -u) "$TARGET_DIR/$PLIST_NAME" 2>/dev/null

    if launchctl bootstrap gui/$(id -u) "$TARGET_DIR/$PLIST_NAME"; then
      echo "✓ Key mapping loaded successfully."
    else
      echo "⚠️ Agent loading failed, but file was copied. It will activate after restart."
    fi
  fi
}

echo -e "${GREEN}✨ Installation Complete!${NC}"
