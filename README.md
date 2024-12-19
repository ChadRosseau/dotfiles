# Dotfiles

This repository contains my personal dotfiles for the variety of tools I use. Currently, this includes:

- zsh
- ghostty
- nvim

## Getting Started

### Prerequisite Installations

#### Terminal

- zsh
- oh-my-zsh
- powerlevel10k
- ghostty

#### Editor

- nvim

#### Fonts

- MesloLGS NF font

### Symlinks

Dotfiles are linked to various applications via symlinks. Run the following commands to create these symlinks. If you already have existing config files, you will need to delete or rename them for the symlinks to work. Ensure to back up any existing config.

```zsh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/ghostty ~/.config/ghostty
```

#### API Keys

API Keys are set via using the `api_keys` file in this repository. Rename the `api_keys.sample` file to simply `api_keys` in order to start using it. Ensure to populate the file as needed with your own keys.
