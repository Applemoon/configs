# MacOS configs by Uvarov

macOS config files for zsh, nvim, vim, git, and Karabiner. The installer **symlinks** everything into `$HOME`, so the repo stays the single source of truth.

## Includes

- **zsh** — Oh My Zsh with Powerlevel10k, syntax highlighting, autosuggestions, eza
- **nvim** — LazyVim (plugins pinned via `lazy-lock.json`); primary editor
- **vim** — Gruvbox, vim-airline, and other plugins via Pathogen; lightweight fallback
- **git** — shared config pulled in via `include.path`
- **Karabiner-Elements** — `fn+hjkl` → arrow keys, right cmd → backspace
- **Fonts** — MesloLGS NF (required for Powerlevel10k)

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Applemoon/configs/HEAD/install.sh)"
```

> This pipes a remote script into your shell — [read `install.sh`](install.sh) before running it. It backs up any files it overwrites to `*.backup`.

## After install

1. Set **MesloLGS NF** as the terminal font
2. Reload terminal session
3. Run `p10k configure` to set up the prompt (or skip — it runs automatically on first launch)
