#!/bin/bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Проверки ─────────────────────────────────────────────────────────────────
[[ -f ".vimrc" && -f ".gitconfig" ]] \
  || error "Запусти скрипт из корня репо: cd ~/dotfiles && ./install.sh"

command -v brew &>/dev/null || error "Homebrew не установлен: https://brew.sh"

# ─── Homebrew ─────────────────────────────────────────────────────────────────
info "Обновляю Homebrew..."
brew update

info "Устанавливаю пакеты из Brewfile..."
brew bundle

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Устанавливаю Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  warn "Oh My Zsh уже установлен — пропускаю"
fi

# ─── you-should-use ───────────────────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
YOU_SHOULD_USE_DIR="$ZSH_CUSTOM/plugins/you-should-use"

if [[ ! -d "$YOU_SHOULD_USE_DIR" ]]; then
  info "Клонирую плагин you-should-use..."
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$YOU_SHOULD_USE_DIR"
else
  warn "you-should-use уже установлен — пропускаю"
fi

# ─── plugins в .zshrc ─────────────────────────────────────────────────────────
PLUGINS_LINE="plugins=(git you-should-use macos z history)"

if grep -qF "$PLUGINS_LINE" "$HOME/.zshrc" 2>/dev/null; then
  warn "plugins уже обновлены — пропускаю"
elif grep -q "^plugins=(" "$HOME/.zshrc" 2>/dev/null; then
  info "Обновляю plugins в .zshrc..."
  sed -i '' "s/^plugins=(.*$/$PLUGINS_LINE/" "$HOME/.zshrc"
else
  warn "Строка plugins=(...) не найдена в .zshrc — пропускаю"
fi

# ─── source-строки в .zshrc ───────────────────────────────────────────────────
BREW_PREFIX="$(brew --prefix)"
ZSH_ADDITIONS="
# ── Added by install.sh ──────────────────────────────────────────────────────
source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh"

if grep -q "Added by install.sh" "$HOME/.zshrc" 2>/dev/null; then
  warn "source-строки уже есть в .zshrc — пропускаю"
else
  info "Дописываю source-строки в .zshrc..."
  echo "$ZSH_ADDITIONS" >> "$HOME/.zshrc"
fi

# ─── Vim ──────────────────────────────────────────────────────────────────────
backup_and_copy() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -e "${dst}.backup" ]]; then
    warn "Сохраняю $dst → ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  cp -r "$src" "$dst"
  info "Скопирован: $src → $dst"
}

backup_and_copy ".vim"   "$HOME/.vim"
backup_and_copy ".vimrc" "$HOME/.vimrc"

# ─── .gitconfig ───────────────────────────────────────────────────────────────
if grep -qF "$(cat .gitconfig)" "$HOME/.gitconfig" 2>/dev/null; then
  warn ".gitconfig уже содержит эти настройки — пропускаю"
else
  info "Добавляю .gitconfig..."
  cat .gitconfig >> "$HOME/.gitconfig"
fi

# ─── Karabiner ────────────────────────────────────────────────────────────────
if [[ -f "karabiner.json" ]]; then
  KARABINER_DIR="$HOME/.config/karabiner"
  mkdir -p "$KARABINER_DIR"
  if [[ -f "$KARABINER_DIR/karabiner.json" && ! -f "$KARABINER_DIR/karabiner.json.backup" ]]; then
    warn "Сохраняю существующий karabiner.json → karabiner.json.backup"
    cp "$KARABINER_DIR/karabiner.json" "$KARABINER_DIR/karabiner.json.backup"
  fi
  cp "karabiner.json" "$KARABINER_DIR/karabiner.json"
  info "Karabiner конфиг скопирован"
else
  warn "karabiner.json не найден в репо — пропускаю"
fi


# ─── Git submodules ───────────────────────────────────────────────────────────
info "Обновляю submodules..."
git submodule sync
git submodule update --init --recursive

# ─── macOS defaults ───────────────────────────────────────────────────────────
info "Применяю macOS настройки..."

defaults write NSGlobalDomain   AppleShowAllExtensions -bool true    # показывать расширения файлов
defaults write com.apple.finder ShowPathbar            -bool true    # путь к файлу внизу окна Finder
defaults write com.apple.dock   show-recents           -bool false   # убрать недавние приложения из Dock
defaults write com.apple.dock   orientation            -string "left" # Dock слева

killall Finder
killall Dock

info "✓ Готово! Выполни: source ~/.zshrc"
