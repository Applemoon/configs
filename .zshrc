# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git you-should-use macos z history eza command-not-found extract)

source $ZSH/oh-my-zsh.sh

# ── User configuration ────────────────────────────────────────────────────────

# Preferred editor for local and remote sessions
export EDITOR="nvim"
export VISUAL="nvim"

alias v=nvim
command -v bat &>/dev/null && alias cat=bat
alias flashcards='cd ~/Developer/flashcards && ./gradlew bootRun'

# Clickable terminal links (e.g. file paths in Claude Code)
export FORCE_HYPERLINK=1

# ── Homebrew-installed zsh extras (portable across /opt/homebrew & /usr/local) ─
for _brew_prefix in /opt/homebrew /usr/local; do
  [[ -d "$_brew_prefix/share/powerlevel10k" ]] && BREW_PREFIX="$_brew_prefix" && break
done
if [[ -n "${BREW_PREFIX:-}" ]]; then
  source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
unset _brew_prefix

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── eza ───────────────────────────────────────────────────────────────────────
export EZA_ICONS_AUTO=1

# отображение файлов при переходе в папку
chpwd() {
    local count=$(eza -1 | wc -l)

    if (( count <= 30 )); then
        eza --icons=always
    else
        echo "$count files"
    fi
}

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Local secrets (NOT tracked in git) ─────────────────────────────────────────
# Tokens/keys live in ~/.zshrc.local, which is outside this repo so it never syncs.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
