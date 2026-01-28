# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-28

### Added
- Automated backup script (`backup.sh`) with multiple modes:
  - Full backup (update + archive + commit + push)
  - Update submodule only
  - Create archive only
  - Commit and push changes
  - Show status
- Automated restore script (`restore.sh`) with safety features:
  - Full restore (dotfiles + Niri + SDDM)
  - Selective restore (dotfiles, Niri, or SDDM individually)
  - Automatic backup of current configuration before restore
  - Interactive and CLI modes
- Comprehensive README.md documentation
- .gitignore for excluding temporary and sensitive files
- Git submodules for Janus-Arch-Linux repository
- Two backup archives:
  - janus-arch-linux-v1.1.0-20260124.tar.gz (original backup)
  - janus-arch-linux-v20260128.tar.gz (updated backup)
- MIT License
- This CHANGELOG

### Changed
- Forked Janus-Arch-Linux from fools-stack to Riain-stack account
- Updated submodule URL to point to Riain-stack fork
- Configured SSH authentication with Riain-stack GitHub account

### Removed
- Redundant test-extract directory
- Nested duplicate janus-backup directory

### Fixed
- Submodule access issues due to suspended fools-stack account

## [Unreleased]

### Planned
- Scheduled automatic backups
- Configuration comparison tool
- Backup verification system
- Multiple backup profiles

---

[1.0.0]: https://github.com/Riain-stack/janus-backup/releases/tag/v1.0.0
