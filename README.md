# Janus Arch Linux Backup

[![Release](https://img.shields.io/github/v/release/Riain-stack/janus-backup?style=flat-square)](https://github.com/Riain-stack/janus-backup/releases)
[![License](https://img.shields.io/github/license/Riain-stack/janus-backup?style=flat-square)](LICENSE)
[![Janus Version](https://img.shields.io/badge/Janus-v1.1.0-blue?style=flat-square)](https://github.com/Riain-stack/Janus-Arch-Linux)
[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?style=flat-square&logo=arch-linux&logoColor=white)](https://archlinux.org/)

> 🔄 Automated backup and restore system for Janus Arch Linux configurations

Personal backup repository for [Janus Arch Linux](https://github.com/Riain-stack/Janus-Arch-Linux) with automated backup/restore scripts and complete configuration management.

## ✨ Features

- 🚀 **One-command backup** - Automated backup with `./backup.sh --full`
- 🔒 **Safe restoration** - Automatic backup before restore
- 📦 **Version control** - Git-based with proper submodules
- 🎯 **Selective restore** - Choose what to restore (dotfiles, Niri, SDDM)
- 🎨 **Interactive mode** - User-friendly menus for both scripts
- 📊 **Status tracking** - View backups and repository state
- ⚡ **Fast compression** - Automated archive creation

## 📦 Contents

This backup contains:

- **Janus-Arch-Linux/** - Full Janus Arch Linux repository (v1.1.0+)
  - Niri window manager configuration
  - SDDM display manager with custom themes
  - Dotfiles (shell, terminal, editor, git, etc.)
  - Installation and update scripts
  - Package lists and dependencies
  - Documentation and guides

- **Backup Archives** - Compressed snapshots
  - `janus-arch-linux-v1.1.0-20260124.tar.gz` - Original backup (Jan 24, 2026)
  - `janus-arch-linux-v20260128.tar.gz` - Latest backup (Jan 28, 2026)

## 🚀 Quick Start

### Backup Current Configuration
```bash
cd janus-backup
./backup.sh --full    # Full automated backup
```

### Restore from Backup
```bash
cd janus-backup
./restore.sh --full   # Full restore with safety backup
```

### Check Status
```bash
./backup.sh --status  # View repository status and backups
```

## 📖 About Janus Arch Linux

Janus is a modern, developer-focused Arch Linux distribution featuring:

- **Niri Window Manager** - Modern scrollable-tiling Wayland compositor
- **SDDM Display Manager** - Beautiful and customizable login screen
- **Developer Tools** - Pre-configured development environment
- **Minimal & Fast** - Lightweight setup focused on performance

### Key Components

| Component | Details |
|-----------|---------|
| Display Manager | SDDM with Astronaut theme |
| Window Manager | Niri (Wayland) |
| Terminal | Foot/Alacritty/Kitty |
| Shell | Zsh with modern completions |
| Editor | Neovim with LSP support |
| Launcher | Fuzzel/Rofi |
| Audio | PipeWire with WirePlumber |

## 🔄 Restoring from Backup

### Automated Restore (Recommended)

Use the included restore script for easy automated restoration:

```bash
cd janus-backup
./restore.sh --full    # Full restore (dotfiles + Niri + SDDM)
```

**Interactive Mode:**
```bash
./restore.sh           # Launch interactive menu
```

**Available Options:**
- `./restore.sh --full` or `-f` - Full restore (dotfiles + Niri + SDDM)
- `./restore.sh --dotfiles` or `-d` - Restore dotfiles only
- `./restore.sh --niri` or `-n` - Restore Niri configuration only
- `./restore.sh --sddm` or `-s` - Restore SDDM configuration only
- `./restore.sh --install` or `-i` - Run Janus installation scripts
- `./restore.sh --help` or `-h` - Show help message

**Safety Features:**
- Automatically backs up current configuration before restoring
- Backups saved to `~/.janus-backups/restore_backup_TIMESTAMP/`
- Confirmation prompts before making changes
- Color-coded output for clarity

### Manual Restore Options

**Option 1: Use the Git Repository**

```bash
git clone https://github.com/Riain-stack/janus-backup.git
cd janus-backup
git submodule update --init --recursive
cd Janus-Arch-Linux
./scripts/install.sh
```

**Option 2: Use the Compressed Archive**

```bash
tar -xzf janus-arch-linux-v1.1.0-20260124.tar.gz
cd Janus-Arch-Linux
./scripts/install.sh
```

**Option 3: Quick Restore Specific Configs**

```bash
# Restore dotfiles only
cd Janus-Arch-Linux/dotfiles
cp -r shell/.zshrc ~/
cp -r terminal/alacritty ~/.config/
cp -r editor/nvim ~/.config/

# Restore Niri config
cp -r Janus-Arch-Linux/niri ~/.config/

# Restore SDDM theme
sudo cp -r Janus-Arch-Linux/sddm/* /etc/sddm/
```

## Updating This Backup

### Automated Backup (Recommended)

Use the included backup script for easy automated backups:

```bash
cd janus-backup
./backup.sh --full    # Full backup (update + archive + commit + push)
```

**Interactive Mode:**
```bash
./backup.sh           # Launch interactive menu
```

**Available Options:**
- `./backup.sh --full` or `-f` - Full backup (update + archive + commit + push)
- `./backup.sh --update` or `-u` - Update Janus submodule only
- `./backup.sh --archive` or `-a` - Create compressed archive only
- `./backup.sh --commit` or `-c` - Commit and push changes
- `./backup.sh --status` or `-s` - Show repository status
- `./backup.sh --help` or `-h` - Show help message

### Manual Backup

To manually update this backup with the latest Janus changes:

```bash
cd janus-backup/Janus-Arch-Linux
git pull origin master
cd ..
git add Janus-Arch-Linux
git commit -m "Update Janus Arch Linux to latest version"
git push
```

To manually create a new compressed archive:

```bash
cd janus-backup
tar -czf janus-arch-linux-v$(date +%Y%m%d).tar.gz Janus-Arch-Linux/
git add janus-arch-linux-v*.tar.gz
git commit -m "Add new backup archive $(date +%Y-%m-%d)"
git push
```

## 📁 Repository Structure

```
janus-backup/
├── backup.sh                  # Automated backup script
├── restore.sh                 # Automated restore script
├── README.md                  # This file
├── CHANGELOG.md              # Version history
├── LICENSE                    # MIT License
├── .gitignore                # Git ignore rules
├── .gitmodules               # Submodule configuration
├── Janus-Arch-Linux/         # Git submodule (Janus repo)
│   ├── sddm/                 # SDDM configuration and themes
│   ├── niri/                 # Niri window manager config
│   ├── dotfiles/             # User configuration files
│   │   ├── shell/            # Zsh, bash configurations
│   │   ├── terminal/         # Terminal emulator configs
│   │   ├── editor/           # Neovim configs
│   │   ├── git/              # Git configuration
│   │   ├── waybar/           # Waybar status bar
│   │   ├── mako/             # Notification daemon
│   │   ├── rofi/             # Application launcher
│   │   └── fastfetch/        # System info tool
│   ├── scripts/              # Installation and setup scripts
│   ├── packages/             # Package lists
│   └── docs/                 # Documentation
└── *.tar.gz                  # Compressed backup archives
```

## 📚 Documentation

For detailed information, see the documentation:

- **This Repository:**
  - [CHANGELOG.md](CHANGELOG.md) - Version history and changes
  - [LICENSE](LICENSE) - MIT License terms
  
- **Janus Documentation:**
  - [Installation Guide](Janus-Arch-Linux/docs/INSTALLATION.md)
  - [Customization Guide](Janus-Arch-Linux/docs/CUSTOMIZATION.md)
  - [Contributing Guidelines](Janus-Arch-Linux/docs/CONTRIBUTING.md)
  - [Janus Changelog](Janus-Arch-Linux/CHANGELOG.md)

## 📝 Notes

- 🔒 This is a personal backup repository
- 🔗 Submodules point to [Riain-stack/Janus-Arch-Linux](https://github.com/Riain-stack/Janus-Arch-Linux) (forked from original)
- ⚠️ Regular backups recommended before major system changes
- ✅ All restore operations create automatic safety backups
- 🧪 Test in a safe environment before production use

## 📄 License

This backup repository is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

Janus Arch Linux is also licensed under the MIT License. See the [Janus repository](https://github.com/Riain-stack/Janus-Arch-Linux) for details.

## 🙋 Support

For issues or questions:
- **Backup scripts**: [Open an issue](https://github.com/Riain-stack/janus-backup/issues)
- **Janus Linux**: See [Janus documentation](https://github.com/Riain-stack/Janus-Arch-Linux)

---

<div align="center">

**Made with ❤️ for Arch Linux enthusiasts**

[![GitHub](https://img.shields.io/badge/GitHub-Riain--stack-181717?style=flat-square&logo=github)](https://github.com/Riain-stack)
[![Janus](https://img.shields.io/badge/Janus-Arch%20Linux-1793D1?style=flat-square)](https://github.com/Riain-stack/Janus-Arch-Linux)

**Latest Backup:** January 28, 2026 | **Janus Version:** v1.1.0

</div>
