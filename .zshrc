# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Homebrew ──────────────────────────────────────────────────────────────────
# Must come before anything that looks up brew-installed commands (aliases,
# plugins): /opt/homebrew/bin is not in /etc/paths the way /usr/local/bin is,
# so without this the native Apple-silicon brew is invisible at this point.
# Guarded: harmless if brew is not installed.
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# fzf-tab goes last: it must load after compinit and before the widget-wrapping
# plugins (autosuggestions, syntax-highlighting), which are sourced further down.
plugins=(git you-should-use macos z history eza command-not-found extract fzf-tab)

source $ZSH/oh-my-zsh.sh

# ── fzf ───────────────────────────────────────────────────────────────────────
# Ctrl-R fuzzy history, Ctrl-T fuzzy file path into the command line,
# Alt-C fuzzy cd. Without this line fzf is only a binary.
source <(fzf --zsh)
# fzf-tab: while picking a directory after `cd`, show its contents on the right —
# the same instinct as the chpwd hook below, one step earlier.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
# macOS /usr/bin/sort under en_US.UTF-8 collates distinct Cyrillic strings as
# equal, so fzf-tab's `sort -u` dedup silently dropped vault folders
# (Инбоксик, Журналы, Архив) from `cd <Tab>`. Byte-order collation fixes sort,
# uniq and comm for Cyrillic everywhere; eza and Obsidian sort on their own.
export LC_COLLATE=C

# ── User configuration ────────────────────────────────────────────────────────

# Preferred editor for local and remote sessions
export EDITOR="nvim"
export VISUAL="nvim"

alias v=nvim
alias cl=claude

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
export EZA_ICONS_AUTO=auto

# отображение файлов при переходе в папку
# только в интерактивном шелле: в фоновых/скриптовых zsh командная подстановка
# в chpwd-хуке ловит race на SIGCHLD и вешает процесс намертво
chpwd() {
    [[ -o interactive ]] || return
    local -a items=(*(N))  # подсчёт глоббингом: без форка ($(eza|wc) и был источником race)

    if (( ${#items} <= 40 )); then
        l
    else
        echo "${#items} files"
    fi
}

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# Обёртки из claude-configs (~/.claude - его чекаут на рабочем GitLab): workon
# и всё, что появится там дальше. Под гардом: на машине без этого репозитория
# строка молча ничего не делает.
[[ -d "$HOME/.claude/bin" ]] && export PATH="$HOME/.claude/bin:$PATH"

# ── Local secrets (NOT tracked in git) ─────────────────────────────────────────
# Tokens/keys live in ~/.zshrc.local, which is outside this repo so it never syncs.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
