# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles repo (zsh, vim, git, Karabiner). This is the **canonical source of truth** for the user's configs — when editing any config (vim/git/karabiner/brew), edit it here first. Home-directory copies (`~/.vimrc`, etc.) are real files, not symlinks, and may drift from the repo. A setting that should persist must be put in **both** the repo and the home copy.

There is no build, lint, or test suite. The only "command" is the installer.

## Install / apply changes

```bash
bash install.sh          # idempotent; re-run to apply repo changes to the machine
```

`install.sh` is the heart of the repo and the only executable. It is **idempotent** — every step guards against re-running (greps for markers, checks for existing dirs, backs up before overwrite). When adding a new config step, preserve this property: guard the step, and back up the user's existing file to `*.backup` before copying over it (see `backup_and_copy`).

What it does, in order: bootstraps Homebrew → `brew bundle` from `Brewfile` → copies fonts → installs Oh My Zsh + the `you-should-use` plugin → rewrites the `plugins=(...)` line and appends a marked block to `~/.zshrc` → copies `.vim`/`.vimrc` (with backup) → appends `.gitconfig` → copies `karabiner.json` to `~/.config/karabiner/` → syncs git submodules → applies `defaults write` macOS tweaks.

When run via `curl` (no `.vimrc` in cwd), it first clones the repo with `--recurse-submodules` and re-execs itself.

## Architecture notes

- **Vim plugins are git submodules** under `.vim/bundle/`, loaded by **Pathogen** (`pathogen#infect()` in `.vimrc`). To add a plugin: `git submodule add <url> .vim/bundle/<name>`, then add it to `.gitmodules`. Don't hand-edit files inside `bundle/` — they're upstream checkouts.
- **`.zshrc` is not in this repo.** zsh config lives only in the user's home `~/.zshrc`; the installer mutates it (plugins line + a fenced `# Added by install.sh` block with the bat alias and p10k/syntax-highlighting/autosuggestions `source` lines). Powerlevel10k itself comes from Homebrew, not Oh My Zsh themes.
- **`.gitconfig`** in the repo is a fragment that gets *appended* to `~/.gitconfig`, not a full config.
- **`karabiner.json`** — full Karabiner-Elements profile. Key rules: `fn+hjkl`→arrows, right cmd→backspace, and Hyper (⌘⌃⌥⇧) `+a/+s/+d` → switch input source to Russian/English/Serbian.
- **Fonts** — `MesloLGS NF` (`fonts/*.ttf`) is required by Powerlevel10k; installed by copying into `~/Library/Fonts/`.

## Gotchas

- The README raw-install URL and the clone URL inside `install.sh` both hardcode `Applemoon/configs` — keep them in sync if the remote ever changes.
- `.gitignore` ignores `.vim/.netrwhist`.
