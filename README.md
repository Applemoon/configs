# MacOS configs by Uvarov

macOS config files for zsh, nvim, vim, git, Ghostty and Karabiner, plus the Homebrew packages and apps they rely on. The installer **symlinks** everything into `$HOME`, so the repo stays the single source of truth.

## Includes

- **Homebrew** — CLI tools and apps from [`Brewfile`](Brewfile); the installer installs and upgrades only what it declares
- **zsh** — Oh My Zsh with Powerlevel10k, syntax highlighting, autosuggestions, eza, fzf + fzf-tab, you-should-use
- **nvim** — LazyVim (plugins pinned via `lazy-lock.json`); primary editor
- **vim** — Gruvbox, vim-airline, and other plugins via Pathogen; lightweight fallback
- **git** — shared config pulled in via `include.path`
- **Ghostty** — terminal config and cursor shaders
- **Karabiner-Elements** — Caps Lock → Hyper (⌘⌃⌥⇧), Hyper+a/s/d → Russian / English / Serbian Cyrillic↔Latin, right cmd → backspace
- **Claude Code status line** — ccstatusline config (the tool itself comes from npm)
- **CLI helpers** — `ascii-cols`, `ask-codex` in `~/.local/bin`
- **Finder Quick Action** — right-click a folder → Open Claude Code in Ghostty (a new tab in the front window)
- **Vorssaint** — menu bar toolkit settings, imported only where the app has no settings yet
- **macOS defaults** — file extensions and Finder path bar shown, Dock on the left without recent apps
- **Fonts** — MesloLGS NF (required for Powerlevel10k)

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Applemoon/configs/HEAD/install.sh)"
```

It asks where to clone the repo (default `~/Developer/configs`) and continues from there. To re-apply later, run `bash install.sh` inside the clone — it is idempotent.

> This pipes a remote script into your shell — [read `install.sh`](install.sh) before running it. It backs up any files it overwrites to `*.backup`. It also runs `brew update`, applies the macOS defaults above and restarts Finder and Dock.

## After install

1. Set **MesloLGS NF** as the terminal font
2. Reload terminal session
3. The prompt comes preconfigured from `.p10k.zsh`. Don't run `p10k configure`: it replaces the `~/.p10k.zsh` symlink with a plain file, and the repo no longer drives the prompt. Edit `.p10k.zsh` in the repo instead.
