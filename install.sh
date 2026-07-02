#!/bin/bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Clone repo if running via curl ──────────────────────────────────────────
REPO_URL="https://github.com/Applemoon/configs.git"
if [[ ! -f ".vimrc" ]]; then
  printf "Clone to? [~/Developer/configs]: " && read -r DIR
  DIR="${DIR:-$HOME/Developer/configs}"
  DIR="${DIR/#\~/$HOME}"
  git clone --recurse-submodules "$REPO_URL" "$DIR"
  cd "$DIR"
  exec bash install.sh
fi

# Absolute path to the repo — symlinks must point here, not at a relative path.
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

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
# OMZ writes its own ~/.zshrc; we overwrite it with our symlink in the link step.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  warn "Oh My Zsh is already installed — skipping"
fi

# ─── you-should-use plugin ─────────────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
YOU_SHOULD_USE_DIR="$ZSH_CUSTOM/plugins/you-should-use"

if [[ ! -d "$YOU_SHOULD_USE_DIR" ]]; then
  info "Cloning you-should-use plugin..."
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$YOU_SHOULD_USE_DIR"
else
  warn "you-should-use is already installed — skipping"
fi

# ─── Git submodules (vim plugins) ──────────────────────────────────────────────
# Must run before linking ~/.vim so .vim/bundle/* are populated.
info "Updating submodules..."
git submodule sync
git submodule update --init --recursive

# ─── Symlinks ──────────────────────────────────────────────────────────────────
# Repo is the single source of truth: link configs into place instead of copying,
# so edits in the repo are live immediately and never drift.
link() {
  local src="$REPO_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ "$(readlink "$dst" 2>/dev/null)" == "$src" ]]; then
    info "Already linked: $dst"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ ! -e "${dst}.backup" ]]; then
      warn "Backing up $dst → ${dst}.backup"
      mv "$dst" "${dst}.backup"
    else
      rm -rf "$dst"   # backup already exists from a previous run
    fi
  fi
  ln -s "$src" "$dst"
  info "Linked: $dst → $src"
}

link ".zshrc"         "$HOME/.zshrc"
link ".p10k.zsh"      "$HOME/.p10k.zsh"
link ".vimrc"         "$HOME/.vimrc"
link ".vim"           "$HOME/.vim"
link "nvim"           "$HOME/.config/nvim"
link "karabiner.json" "$HOME/.config/karabiner/karabiner.json"
link "ghostty/config"  "$HOME/.config/ghostty/config"
link "ghostty/shaders" "$HOME/.config/ghostty/shaders"

# ─── .gitconfig (via include, keeps user's name/email intact) ───────────────────
GITCONFIG_PATH="$REPO_DIR/.gitconfig"
if git config --global --get-all include.path 2>/dev/null | grep -qxF "$GITCONFIG_PATH"; then
  warn ".gitconfig include already present — skipping"
else
  info "Adding include.path to ~/.gitconfig..."
  git config --global --add include.path "$GITCONFIG_PATH"
fi

# ─── macOS defaults ───────────────────────────────────────────────────────────
info "Applying macOS settings..."

defaults write NSGlobalDomain   AppleShowAllExtensions -bool true     # show all file extensions
defaults write com.apple.finder ShowPathbar            -bool true     # show path bar in Finder
defaults write com.apple.dock   show-recents           -bool false    # hide recent apps from Dock
defaults write com.apple.dock   orientation            -string "left" # Dock on the left

killall Finder || true
killall Dock || true

info "✓ Done! Run: source ~/.zshrc"
