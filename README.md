# ssuarezs.dots

High-performance development environment configuration, optimized for **macOS (Apple Silicon)** and **Linux**.

This repository manages my dotfiles using **GNU Stow** and **Homebrew**, ensuring a **reproducible**, **stable**, and easy-to-maintain setup.

---

## 🛠 Tech Stack

- **Shell**: Zsh + Oh My Posh
- **Editor**: Neovim (LazyVim-based)
- **Terminal**: Alacritty/Wezterm + Tmux
- **Package Manager**: Homebrew

### Runtimes

- **Node.js** (via `fnm`)
- **Python** (via `uv`)

### Utilities

- Zoxide
- Eza
- Ripgrep
- FZF
- Bat
- LazyGit

---

## 🚀 Quick Installation

### 1️⃣ Clone the repository

```bash
git clone https://github.com/ssuarezs/ssuarezs.dots.git ~/dotfiles
cd ~/dotfiles
```

### 2️⃣ Run the bootstrapper

This script detects your operating system (macOS or Linux), installs missing dependencies, and symlinks configuration files using GNU Stow.

```bash
chmod +x install.sh
./install.sh
```

### 3️⃣ Post-installation

- Restart your terminal to load Zsh.
- Open **Tmux** and press `Ctrl+a` followed by `I` (`Shift+i`) to install plugins.
- Open **Neovim** (`v` or `nvim`) and let LazyVim install its dependencies automatically.

---

## 📂 Project Structure

```text
~/dotfiles
├── install.sh          # Smart installation script (OS agnostic)
├── homebrew/
│   └── Brewfile        # Package and application list
├── zsh/
│   ├── .zshrc          # Main shell configuration
│   └── .config/        # Oh My Posh themes
├── nvim/
│   └── .config/nvim/   # Neovim configuration (LazyVim)
├── tmux/
│   └── .tmux.conf      # Tmux configuration + TPM
├── alacritty/
│   └── .config/        # Alacritty configuration (TOML)
├── wezterm/
│   └── .config/        # Wezterm configuration (LUA)
└── git/
    ├── .gitconfig      # Git identity and aliases
    └── .gitignore_global
```

---

## 📄 License

This project is licensed under the **MIT License**.

You are free to use, modify, and distribute this software.