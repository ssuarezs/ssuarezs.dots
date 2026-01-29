# Agent Guidelines for Dotfiles Repository

This is a personal dotfiles repository for managing development environment configurations
across macOS and Linux using GNU Stow and Homebrew.

## Repository Overview

**Type:** Configuration management (dotfiles)  
**Purpose:** Reproducible development environment setup  
**Primary Tools:** GNU Stow, Homebrew, Zsh, Neovim (LazyVim), Tmux  
**Supported Platforms:** macOS (Apple Silicon/Intel), Linux

## Build/Lint/Test Commands

This is NOT a traditional code project. There are no build, test, or CI/CD pipelines.

### Installation Commands

```bash
# Full bootstrap installation (sets up entire environment)
./install.sh

# Manual Stow commands (symlink individual configurations)
stow zsh nvim alacritty tmux git wezterm ghostty

# Install packages via Homebrew
brew bundle --file=./homebrew/Brewfile

# Apply macOS system defaults (macOS only)
source ./macos/defaults.sh

# Format Lua files (Neovim config only)
stylua nvim/.config/nvim/
```

### Verification Commands

```bash
# Verify symlinks are correct
ls -la ~/ | grep "\->"

# Check Homebrew bundle status
brew bundle check --file=./homebrew/Brewfile

# Verify shell configuration
source ~/.zshrc

# Test Neovim config (launch and check for errors)
nvim +checkhealth
```

## Code Style Guidelines

### Shell Scripts (Bash)

**Files:** `install.sh`, `macos/defaults.sh`

**Style:**

- Use `#!/bin/bash` shebang
- 2-space indentation
- Use `snake_case` for function names
- Quote all variables: `"$VAR"` not `$VAR`
- Use `[[` instead of `[` for conditionals
- Add descriptive comments with section headers
- Use color output for user feedback: `echo -e "${BLUE}message${NC}"`
- Check command existence with: `command -v tool &>/dev/null`
- Cross-platform path detection (macOS vs Linux)

**Example:**

```bash
if [[ "$(uname)" == "Darwin" ]]; then
  echo -e "${BLUE}🍎 Applying macOS defaults...${NC}"
  source ./macos/defaults.sh
fi
```

### Nvim/Lua Configuration

**Files:** Neovim config in `nvim/.config/nvim/`

**Formatter:** StyLua with config at `nvim/.config/nvim/stylua.toml`

- 2-space indentation (Spaces, not tabs)
- 120 column width
- Run: `stylua nvim/.config/nvim/`

**Style:**

- Use `local` for all variables unless global needed
- Descriptive variable names in `snake_case`
- Use double quotes for strings
- Comment section headers with decorative boxes
- Require modules at top: `local wezterm = require("wezterm")`
- Use vim.opt for Neovim options: `vim.opt.spell = true`
- Prefer LazyVim conventions and plugin structure

**Example:**

```lua
-- ┌──────────────────────────────────────────────────┐
-- │                   FONT SETTINGS                  │
-- └──────────────────────────────────────────────────┘

local config = {}
config.font = wezterm.font("IosevkaTerm NF")
config.font_size = 16.0
```

### Configuration Files

**TOML (Alacritty, StyLua):**

- Use snake_case for keys
- Inline tables for related settings
- Group related settings with comments

**Shell Configuration (.zshrc):**

- Numbered sections with descriptive headers
- Use `export` for environment variables
- Quote paths with spaces
- Source external files with full paths using `$(brew --prefix)`
- Prefer modern CLI tool aliases (eza over ls, bat over cat)

### Git Configuration

**Commit Messages:**

- Use imperative mood: "Add feature" not "Added feature"
- Keep first line under 50 characters
- Reference file paths when relevant
- Common prefixes: Add, Update, Fix, Remove, Refactor, Configure

**Example:**

```text
Add WezTerm cursor blink configuration

Configure cursor blink rate and easing in wezterm/.config/wezterm/wezterm.lua
```

## Naming Conventions

### Files and Directories

- Dotfiles: Use actual dot prefix (`.gitconfig`, `.zshrc`)
- Config directories: No dots, match application names (`nvim/`, `alacritty/`)
- Scripts: Lowercase with extensions (`.sh` for shell scripts)
- Lua configs: `lowercase.lua` or `kebab-case.lua`

### Variables

- **Shell:** `UPPER_SNAKE_CASE` for exported vars, `lower_snake_case` for local
- **Lua:** `snake_case` for locals, check LazyVim conventions for plugin config

### Functions

- **Shell:** `lower_snake_case` (e.g., `setup_macos_keys`)
- **Lua:** `snake_case` or use module pattern with dot notation

## Directory Structure

```text
dotfiles/
├── install.sh              # Main bootstrap script
├── homebrew/
│   └── Brewfile           # Package declarations
├── zsh/
│   └── .zshrc             # Shell configuration
├── nvim/
│   └── .config/nvim/      # Neovim + LazyVim config
│       ├── init.lua
│       ├── stylua.toml
│       └── lua/
│           ├── config/    # Core configs
│           └── plugins/   # Plugin customizations
├── alacritty/
│   └── .config/alacritty/ # Terminal config
├── wezterm/
│   └── .config/wezterm/   # Alternative terminal
├── ghostty/
│   └── .config/ghostty/   # Alternative terminal
├── tmux/
│   └── .tmux.conf         # Multiplexer config
├── git/
│   ├── .gitconfig         # Git user & aliases
│   └── .gitignore_global  # Global ignore patterns
└── macos/
    ├── defaults.sh        # System preferences
    └── *.plist            # LaunchAgents
```

## Error Handling

### Shell Scripts

- Always check if commands exist before running: `command -v tool &>/dev/null`
- Use `|| return 1` for functions that can fail
- Provide user-friendly error messages with context
- Suppress expected errors: `2>/dev/null`
- Use `set -e` cautiously (not set by default in these scripts)

**Example:**

```bash
if ! command -v brew &>/dev/null; then
  echo "⚠️  Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
```

### Lua Configuration

- Use protected calls for optional modules: `pcall(require, "module")`
- Provide fallback values: `vim.g.node_host_prog = vim.fn.exepath("node") or "/usr/local/bin/node"`
- Check platform before OS-specific config: `if vim.fn.has("wsl") == 1 then`

## Common Tasks

### Adding a New Tool Configuration

1. Create directory matching tool name: `mkdir toolname`
2. Add config files maintaining dot-prefix structure
3. Update `install.sh` to include in stow command
4. Add tool to `homebrew/Brewfile` if needed
5. Test with: `stow --restow toolname`

### Modifying Neovim Config

1. Edit files in `nvim/.config/nvim/lua/`
2. Format with: `stylua nvim/.config/nvim/`
3. Test in Neovim: `:source $MYVIMRC` or restart
4. Check health: `:checkhealth`

### Adding Homebrew Packages

1. Edit `homebrew/Brewfile`
2. Run: `brew bundle --file=./homebrew/Brewfile`
3. Verify: `brew bundle check --file=./homebrew/Brewfile`

### Cross-Platform Considerations

- Always check OS before platform-specific commands
- Use Homebrew prefix detection: `$(brew --prefix)`
- Path variations:
  - `/opt/homebrew` (macOS ARM)
  - `/usr/local` (macOS Intel)
  - `/home/linuxbrew` (Linux)
- macOS-specific: defaults, LaunchAgents, key mappings
- Linux-specific: May need manual font/terminal installation

## Important Notes

- This is NOT a software project - avoid adding tests, CI/CD, or build systems
- Changes should be immediately testable by sourcing configs or restarting applications
- Always test changes on a clean environment when possible
- Stow creates symlinks - editing either location affects the same file
- Keep configurations minimal and well-commented for future maintenance
- Prefer upstream defaults unless there's a strong reason to customize
