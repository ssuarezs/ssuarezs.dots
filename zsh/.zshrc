# --- 1. Homebrew setup (Universal) ---
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # macOS Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    # Linux Default
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    # macOS Intel / Legacy Linux
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "⚠️  Homebrew not found. Check your installation."
fi

# Add local paths
export PATH="$HOME/.local/bin:$PATH"

# --- 2. Global vars ---
export EDITOR='nvim'
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config" # XDG_CONFIG_HOME

# --- 3. Oh My Zsh (Base config) ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="" # Without default theme
plugins=(git sudo docker web-search history)
source $ZSH/oh-my-zsh.sh

# --- 4. Modern tools (Runtimes) ---
# fnm: Node manager
eval "$(fnm env --use-on-cd)"
# uv: Python manager + auto-complete
eval "$(uv generate-shell-completion zsh)"
# zoxide
eval "$(zoxide init zsh)"

# --- 5. Appearance (Oh My Posh) ---
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/catppuccin_mocha.omp.json)"
fi

# --- 6. Advanced Plugins (Homebrew) ---
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  chmod go-w "$(brew --prefix)/share"
  chmod go-w "$(brew --prefix)/share/zsh"
  chmod go-w "$(brew --prefix)/share/zsh/site-functions"
fi

# Init auto-complete 
autoload -Uz compinit
compinit

# Zsh visual plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 7. Optimized History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# --- 8. Alias & Utilities ---

# Modern replace
alias ls="eza --icons --git"
alias ll="eza --icons --git -l"
alias la="eza --icons --git -la"
alias cat="bat"
alias cd="z"

# Quick navigation
alias ..="cd .."
alias ...="cd ../.."

# Git / LazyGit
alias lg="lazygit"
alias ga="git add ."
alias gc="git commit -m"

# Editor
alias v="nvim"
alias vim="nvim"

# Config Reload
alias reload="source ~/.zshrc"

# --- 9. FZF (Finder) ---
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- Auto-Start Tmux ---
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ ! $TERM_PROGRAM =~ "vscode" ]]; then
    tmux attach -t main || tmux new -s main
fi


# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Bun completions
[ -s "/Users/ssuarezs/.bun/_bun" ] && source "/Users/ssuarezs/.bun/_bun"
