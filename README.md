# MacOS configs by Uvarov

macOS config files for zsh, vim, git, and Karabiner.

## Includes

- **zsh** — Oh My Zsh with Powerlevel10k, syntax highlighting, autosuggestions
- **vim** — Gruvbox theme, NERDTree, vim-airline, and other plugins via Pathogen
- **git** — aliases and global config
- **Karabiner-Elements** — `fn+hjkl` → arrow keys, right cmd → backspace
- **Fonts** — MesloLGS NF (required for Powerlevel10k)

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Applemoon/configs/install.sh)"
```

## After install

1. Set **MesloLGS NF** as the terminal font
2. Reload terminal session
3. Run `p10k configure` to set up the prompt (or skip — it runs automatically on first launch)
