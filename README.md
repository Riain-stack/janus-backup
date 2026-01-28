# Janus Arch Linux Backup

Personal backup repository for [Janus Arch Linux](https://github.com/fools-stack/Janus-Arch-Linux) configuration and installation files.

## Contents

This backup contains:

- **Janus-Arch-Linux/** - Full Janus Arch Linux repository (v1.1.0+)
  - Niri window manager configuration
  - SDDM display manager with custom themes
  - Dotfiles (shell, terminal, editor, git, etc.)
  - Installation and update scripts
  - Package lists and dependencies
  - Documentation and guides

- **janus-arch-linux-v1.1.0-20260124.tar.gz** - Compressed archive of the complete setup
  - Snapshot taken: January 24, 2026
  - Version: 1.1.0

- **test-extract/** - Test extraction directory

## About Janus Arch Linux

Janus is a modern, developer-focused Arch Linux distribution featuring:

- **Niri Window Manager** - Modern scrollable-tiling Wayland compositor
- **SDDM Display Manager** - Beautiful and customizable login screen
- **Developer Tools** - Pre-configured development environment
- **Minimal & Fast** - Lightweight setup focused on performance

### Key Components

- Display Manager: SDDM with Astronaut theme
- Window Manager: Niri (Wayland)
- Terminal: Foot/Alacritty/Kitty
- Shell: Zsh with modern completions
- Editor: Neovim with LSP support
- Launcher: Fuzzel/Rofi
- Audio: PipeWire with WirePlumber

## Restoring from Backup

### Option 1: Use the Git Repository

```bash
git clone https://github.com/Riain-stack/janus-backup.git
cd janus-backup/Janus-Arch-Linux
git submodule update --init --recursive
./scripts/install.sh
```

### Option 2: Use the Compressed Archive

```bash
tar -xzf janus-arch-linux-v1.1.0-20260124.tar.gz
cd Janus-Arch-Linux
./scripts/install.sh
```

### Quick Restore Specific Configs

```bash
# Restore dotfiles only
cd Janus-Arch-Linux/dotfiles
./install-dotfiles.sh  # if available, or manually copy

# Restore Niri config
cp -r Janus-Arch-Linux/niri ~/.config/

# Restore SDDM theme
sudo cp -r Janus-Arch-Linux/sddm/* /etc/sddm/
```

## Updating This Backup

To update this backup with the latest Janus changes:

```bash
cd janus-backup/Janus-Arch-Linux
git pull origin master
cd ..
git add Janus-Arch-Linux
git commit -m "Update Janus Arch Linux to latest version"
git push
```

To create a new compressed archive:

```bash
cd janus-backup
tar -czf janus-arch-linux-v$(date +%Y%m%d).tar.gz Janus-Arch-Linux/
git add janus-arch-linux-v*.tar.gz
git commit -m "Add new backup archive $(date +%Y-%m-%d)"
git push
```

## Repository Structure

```
janus-backup/
├── Janus-Arch-Linux/          # Git submodule to main Janus repo
│   ├── sddm/                  # SDDM configuration and themes
│   ├── niri/                  # Niri window manager config
│   ├── dotfiles/              # User configuration files
│   │   ├── shell/             # Zsh, bash configurations
│   │   ├── terminal/          # Terminal emulator configs
│   │   ├── editor/            # Neovim, VSCode configs
│   │   └── git/               # Git configuration
│   ├── scripts/               # Installation and setup scripts
│   ├── packages/              # Package lists
│   └── docs/                  # Documentation
├── test-extract/              # Test extraction directory
└── janus-arch-linux-v1.1.0-20260124.tar.gz  # Compressed backup
```

## Documentation

For detailed information, see the documentation in `Janus-Arch-Linux/docs/`:

- [Installation Guide](Janus-Arch-Linux/docs/INSTALLATION.md)
- [Customization Guide](Janus-Arch-Linux/docs/CUSTOMIZATION.md)
- [Contributing Guidelines](Janus-Arch-Linux/docs/CONTRIBUTING.md)
- [Changelog](Janus-Arch-Linux/CHANGELOG.md)

## Notes

- This is a personal backup repository
- Submodules point to the original [fools-stack/Janus-Arch-Linux](https://github.com/fools-stack/Janus-Arch-Linux) repository
- Regular backups recommended before major system changes
- Test extractions in `test-extract/` before applying to production system

## License

Janus Arch Linux is licensed under the MIT License. See the original repository for details.

---

**Backup Date:** January 24, 2026  
**Janus Version:** v1.1.0  
**Maintained by:** Riain-stack
