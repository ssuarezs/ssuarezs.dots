# --- 1. Configuración de Homebrew (Universal) ---
# Detectar dónde está Homebrew y cargarlo
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # macOS Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    # Linux Default
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # macOS Intel / Linux antiguo
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "⚠️  Homebrew no encontrado. Revisa tu instalación."
fi

# Añadir rutas locales (para herramientas instaladas manualmente si las hubiera)
export PATH="$HOME/.local/bin:$PATH"

# --- 2. Variables Globales ---
export EDITOR='nvim'
export LANG=en_US.UTF-8
# Definir ruta de configuración para herramientas XDG (buena práctica)
export XDG_CONFIG_HOME="$HOME/.config"

# --- 3. Oh My Zsh (Configuración Base) ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="" # Desactivamos tema interno, usamos Oh My Posh
plugins=(git sudo docker web-search history)
source $ZSH/oh-my-zsh.sh

# --- 4. Herramientas Modernas (Runtimes) ---
# fnm: Node manager (con cambio automático si detecta .nvmrc)
eval "$(fnm env --use-on-cd)"
# uv: Python manager + autocompletado
eval "$(uv generate-shell-completion zsh)"
# zoxide: Reemplazo inteligente de 'cd'
eval "$(zoxide init zsh)"

# --- 5. Apariencia (Oh My Posh) ---
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  # Usa un tema por defecto o cambia la ruta a tu archivo .omp.json propio
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/catppuccin_mocha.omp.json)"
fi

# --- 6. Plugins Avanzados (Desde Homebrew) ---
# IMPORTANTE: zsh-completions debe agregarse al fpath ANTES de compinit
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  chmod go-w "$(brew --prefix)/share"
  chmod go-w "$(brew --prefix)/share/zsh"
  chmod go-w "$(brew --prefix)/share/zsh/site-functions"
fi

# Inicializar sistema de autocompletado
autoload -Uz compinit
compinit

# Cargar plugins visuales (siempre al final de la carga de plugins)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 7. Historial Optimizado (Estilo Gentleman) ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS  # No guardar duplicados seguidos
setopt HIST_FIND_NO_DUPS     # No mostrar duplicados al buscar
setopt HIST_IGNORE_SPACE     # Comandos con espacio al inicio no se guardan (para secrets)
setopt HIST_SAVE_NO_DUPS     # No guardar duplicados en el archivo

# --- 8. Alias y Utilidades ---

# Reemplazos modernos
alias ls="eza --icons --git"
alias ll="eza --icons --git -l"
alias la="eza --icons --git -la"
alias cat="bat"
alias cd="z"

# Navegación rápida
alias ..="cd .."
alias ...="cd ../.."

# Git / LazyGit
alias lg="lazygit"
alias ga="git add ."
alias gc="git commit -m"

# Editor
alias v="nvim"
alias vim="nvim"

# Reload de configuración (útil mientras armas tus dotfiles)
alias reload="source ~/.zshrc"

# --- 9. FZF (Buscador) ---
# Usar 'fd' para alimentar a fzf (respeta .gitignore y es más rápido)
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# opencode
export PATH=/Users/ssuarezs/.opencode/bin:$PATH

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/ssuarezs/.bun/_bun" ] && source "/Users/ssuarezs/.bun/_bun"
