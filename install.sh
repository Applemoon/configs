#!/bin/bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Clone repo if running via curl ──────────────────────────────────────────
REPO_URL="https://github.com/Applemoon/configs.git"
if [[ ! -f ".vimrc" ]]; then
  printf "Clone to? [~/Developer/configs]: " && read DIR
  DIR="${DIR:-$HOME/Developer/configs}"
  DIR="${DIR/#\~/$HOME}"
  git clone --recurse-submodules "$REPO_URL" "$DIR"
  cd "$DIR"
  exec bash install.sh
fi

# ─── Homebrew ─────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for this session (Apple Silicon: /opt/homebrew, Intel: /usr/local)
  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$brew_path" ]] && eval "$("$brew_path" shellenv)" && break
  done
fi

info "Updating Homebrew..."
brew update

info "Installing packages from Brewfile..."
brew bundle --no-upgrade

# ─── Fonts ────────────────────────────────────────────────────────────────────
info "Installing fonts..."
cp fonts/*.ttf ~/Library/Fonts/

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  warn "Oh My Zsh is already installed — skipping"
fi

# ─── you-should-use ───────────────────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
YOU_SHOULD_USE_DIR="$ZSH_CUSTOM/plugins/you-should-use"

if [[ ! -d "$YOU_SHOULD_USE_DIR" ]]; then
  info "Cloning you-should-use plugin..."
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$YOU_SHOULD_USE_DIR"
else
  warn "you-should-use is already installed — skipping"
fi

# ─── plugins in .zshrc ────────────────────────────────────────────────────────
# Merge our plugins into the existing list without clobbering the user's own.
DESIRED_PLUGINS="git you-should-use macos z history"

if grep -q "^plugins=(" "$HOME/.zshrc" 2>/dev/null; then
  current="$(sed -n 's/^plugins=(\(.*\))/\1/p' "$HOME/.zshrc")"
  merged="$current"
  for p in $DESIRED_PLUGINS; do
    grep -qw "$p" <<<"$current" || merged="$merged $p"
  done
  merged="$(echo "$merged" | xargs)"  # trim/normalize whitespace
  if [[ "$merged" == "$current" ]]; then
    warn "plugins already up to date — skipping"
  else
    info "Updating plugins in .zshrc..."
    sed -i '' "s/^plugins=(.*$/plugins=($merged)/" "$HOME/.zshrc"
  fi
else
  warn "plugins=(...) line not found in .zshrc — skipping"
fi

# ─── source lines in .zshrc ───────────────────────────────────────────────────
BREW_PREFIX="$(brew --prefix)"
ZSH_ADDITIONS="
# ── Added by install.sh ──────────────────────────────────────────────────────
command -v bat &>/dev/null && alias cat=bat
source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${BREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh"

if grep -q "Added by install.sh" "$HOME/.zshrc" 2>/dev/null; then
  warn "source lines already present in .zshrc — skipping"
else
  info "Appending source lines to .zshrc..."
  echo "$ZSH_ADDITIONS" >> "$HOME/.zshrc"
fi

# ─── Vim ──────────────────────────────────────────────────────────────────────
backup_and_copy() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && ! -e "${dst}.backup" ]]; then
    warn "Backing up $dst → ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  rm -rf "$dst"          # avoid cp -r nesting into an existing dir on re-runs
  cp -r "$src" "$dst"
  info "Copied: $src → $dst"
}

backup_and_copy ".vim"   "$HOME/.vim"
backup_and_copy ".vimrc" "$HOME/.vimrc"

# ─── .gitconfig ───────────────────────────────────────────────────────────────
if grep -q "hist = log" "$HOME/.gitconfig" 2>/dev/null; then
  warn ".gitconfig already contains these settings — skipping"
else
  info "Appending .gitconfig..."
  cat .gitconfig >> "$HOME/.gitconfig"
fi

# ─── Karabiner ────────────────────────────────────────────────────────────────
if [[ -f "karabiner.json" ]]; then
  KARABINER_DIR="$HOME/.config/karabiner"
  mkdir -p "$KARABINER_DIR"
  if [[ -f "$KARABINER_DIR/karabiner.json" && ! -f "$KARABINER_DIR/karabiner.json.backup" ]]; then
    warn "Backing up existing karabiner.json → karabiner.json.backup"
    cp "$KARABINER_DIR/karabiner.json" "$KARABINER_DIR/karabiner.json.backup"
  fi
  cp "karabiner.json" "$KARABINER_DIR/karabiner.json"
  info "Karabiner config copied"
else
  warn "karabiner.json not found in repo — skipping"
fi

# ─── Git submodules ───────────────────────────────────────────────────────────
info "Updating submodules..."
git submodule sync
git submodule update --init --recursive

# ─── macOS defaults ───────────────────────────────────────────────────────────
info "Applying macOS settings..."

defaults write NSGlobalDomain   AppleShowAllExtensions -bool true     # show all file extensions
defaults write com.apple.finder ShowPathbar            -bool true     # show path bar in Finder
defaults write com.apple.dock   show-recents           -bool false    # hide recent apps from Dock
defaults write com.apple.dock   orientation            -string "left" # Dock on the left

killall Finder || true
killall Dock || true

info "✓ Done! Run: source ~/.zshrc"
