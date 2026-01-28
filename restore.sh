#!/bin/bash

# Janus Arch Linux Restore Script
# Automates the process of restoring configurations from backup

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JANUS_DIR="${BACKUP_DIR}/Janus-Arch-Linux"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_LOCATION="$HOME/.janus-backups/restore_backup_${TIMESTAMP}"

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_warning "Running as root. Some operations will use sudo explicitly."
    fi
}

# Create backup of current configuration
backup_current_config() {
    print_step "Creating backup of current configuration..."
    
    mkdir -p "${BACKUP_LOCATION}"
    
    # Backup config directories
    CONFIGS=(
        ".config/niri"
        ".config/foot"
        ".config/alacritty"
        ".config/kitty"
        ".config/nvim"
        ".config/waybar"
        ".config/mako"
        ".config/rofi"
        ".zshrc"
        ".bashrc"
        ".gitconfig"
    )
    
    for config in "${CONFIGS[@]}"; do
        if [ -e "$HOME/$config" ]; then
            PARENT_DIR=$(dirname "${BACKUP_LOCATION}/${config}")
            mkdir -p "${PARENT_DIR}"
            cp -r "$HOME/$config" "${BACKUP_LOCATION}/${config}" 2>/dev/null || true
            print_info "Backed up: $config"
        fi
    done
    
    print_success "Current configuration backed up to: ${BACKUP_LOCATION}"
}

# Restore dotfiles
restore_dotfiles() {
    print_step "Restoring dotfiles..."
    
    if [ ! -d "${JANUS_DIR}/dotfiles" ]; then
        print_error "Dotfiles directory not found!"
        return 1
    fi
    
    cd "${JANUS_DIR}/dotfiles"
    
    # Shell configs
    if [ -d "shell" ]; then
        print_info "Restoring shell configurations..."
        [ -f "shell/.zshrc" ] && cp shell/.zshrc "$HOME/" && print_info "  ✓ .zshrc"
        [ -f "shell/.bashrc" ] && cp shell/.bashrc "$HOME/" && print_info "  ✓ .bashrc"
    fi
    
    # Terminal configs
    if [ -d "terminal" ]; then
        print_info "Restoring terminal configurations..."
        [ -d "terminal/alacritty" ] && mkdir -p "$HOME/.config/alacritty" && cp -r terminal/alacritty/* "$HOME/.config/alacritty/" && print_info "  ✓ Alacritty"
        [ -d "terminal/foot" ] && mkdir -p "$HOME/.config/foot" && cp -r terminal/foot/* "$HOME/.config/foot/" && print_info "  ✓ Foot"
        [ -d "terminal/kitty" ] && mkdir -p "$HOME/.config/kitty" && cp -r terminal/kitty/* "$HOME/.config/kitty/" && print_info "  ✓ Kitty"
    fi
    
    # Editor configs
    if [ -d "editor" ]; then
        print_info "Restoring editor configurations..."
        [ -d "editor/nvim" ] && mkdir -p "$HOME/.config/nvim" && cp -r editor/nvim/* "$HOME/.config/nvim/" && print_info "  ✓ Neovim"
    fi
    
    # Git config
    if [ -d "git" ]; then
        print_info "Restoring git configuration..."
        [ -f "git/.gitconfig" ] && cp git/.gitconfig "$HOME/" && print_info "  ✓ .gitconfig"
    fi
    
    # Waybar
    if [ -d "waybar" ]; then
        print_info "Restoring waybar configuration..."
        mkdir -p "$HOME/.config/waybar"
        cp -r waybar/* "$HOME/.config/waybar/" && print_info "  ✓ Waybar"
    fi
    
    # Mako
    if [ -d "mako" ]; then
        print_info "Restoring mako configuration..."
        mkdir -p "$HOME/.config/mako"
        cp -r mako/* "$HOME/.config/mako/" && print_info "  ✓ Mako"
    fi
    
    # Rofi
    if [ -d "rofi" ]; then
        print_info "Restoring rofi configuration..."
        mkdir -p "$HOME/.config/rofi"
        cp -r rofi/* "$HOME/.config/rofi/" && print_info "  ✓ Rofi"
    fi
    
    # Fastfetch
    if [ -d "fastfetch" ]; then
        print_info "Restoring fastfetch configuration..."
        mkdir -p "$HOME/.config/fastfetch"
        cp -r fastfetch/* "$HOME/.config/fastfetch/" && print_info "  ✓ Fastfetch"
    fi
    
    cd "${BACKUP_DIR}"
    print_success "Dotfiles restored!"
}

# Restore Niri configuration
restore_niri() {
    print_step "Restoring Niri configuration..."
    
    if [ ! -d "${JANUS_DIR}/niri" ]; then
        print_error "Niri directory not found!"
        return 1
    fi
    
    mkdir -p "$HOME/.config/niri"
    cp -r "${JANUS_DIR}/niri/"* "$HOME/.config/niri/"
    
    print_success "Niri configuration restored!"
}

# Restore SDDM (requires sudo)
restore_sddm() {
    print_step "Restoring SDDM configuration..."
    
    if [ ! -d "${JANUS_DIR}/sddm" ]; then
        print_error "SDDM directory not found!"
        return 1
    fi
    
    print_warning "This requires sudo privileges to copy to /etc/sddm/"
    
    if command -v sudo &> /dev/null; then
        sudo mkdir -p /etc/sddm
        sudo cp -r "${JANUS_DIR}/sddm/"* /etc/sddm/
        print_success "SDDM configuration restored!"
    else
        print_error "sudo not available. Please run manually with root privileges:"
        echo "  sudo cp -r ${JANUS_DIR}/sddm/* /etc/sddm/"
        return 1
    fi
}

# Run installation scripts
run_install_scripts() {
    print_step "Running Janus installation scripts..."
    
    if [ -f "${JANUS_DIR}/scripts/install.sh" ]; then
        print_info "Running install.sh..."
        cd "${JANUS_DIR}"
        bash scripts/install.sh
        print_success "Installation script completed!"
    else
        print_warning "install.sh not found, skipping..."
    fi
    
    cd "${BACKUP_DIR}"
}

# Show restore summary
show_summary() {
    echo ""
    echo "=================================="
    echo "  Restore Summary"
    echo "=================================="
    echo -e "${GREEN}✓${NC} Dotfiles restored"
    echo -e "${GREEN}✓${NC} Niri configuration restored"
    echo -e "${GREEN}✓${NC} Previous configuration backed up to:"
    echo "    ${BACKUP_LOCATION}"
    echo ""
    echo "Next steps:"
    echo "  1. Review configurations in ~/.config/"
    echo "  2. Restart your session or reboot"
    echo "  3. If issues occur, restore from: ${BACKUP_LOCATION}"
    echo "=================================="
}

# Main menu
show_menu() {
    echo ""
    echo "=================================="
    echo "  Janus Restore Manager"
    echo "=================================="
    echo "1. Full restore (dotfiles + Niri + SDDM)"
    echo "2. Restore dotfiles only"
    echo "3. Restore Niri configuration only"
    echo "4. Restore SDDM configuration only"
    echo "5. Run Janus installation scripts"
    echo "6. Show backup location"
    echo "7. Exit"
    echo "=================================="
    echo -n "Select an option [1-7]: "
}

# Confirm action
confirm_action() {
    local action="$1"
    echo ""
    print_warning "This will $action"
    print_info "Your current configuration will be backed up to: ${BACKUP_LOCATION}"
    echo -n "Continue? [y/N]: "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            print_info "Operation cancelled"
            return 1
            ;;
    esac
}

# Main script
main() {
    cd "${BACKUP_DIR}"
    check_root
    
    # Check if Janus directory exists
    if [ ! -d "${JANUS_DIR}" ]; then
        print_error "Janus-Arch-Linux directory not found!"
        print_info "Make sure you're running this from the janus-backup directory"
        exit 1
    fi
    
    # If arguments provided, run non-interactive mode
    if [ $# -gt 0 ]; then
        case "$1" in
            --full|-f)
                if confirm_action "restore all configurations"; then
                    backup_current_config
                    restore_dotfiles
                    restore_niri
                    restore_sddm
                    show_summary
                fi
                ;;
            --dotfiles|-d)
                if confirm_action "restore dotfiles"; then
                    backup_current_config
                    restore_dotfiles
                    print_success "Dotfiles restored!"
                fi
                ;;
            --niri|-n)
                if confirm_action "restore Niri configuration"; then
                    backup_current_config
                    restore_niri
                fi
                ;;
            --sddm|-s)
                if confirm_action "restore SDDM configuration"; then
                    restore_sddm
                fi
                ;;
            --install|-i)
                run_install_scripts
                ;;
            --help|-h)
                echo "Usage: $0 [OPTION]"
                echo ""
                echo "Options:"
                echo "  -f, --full      Full restore (dotfiles + Niri + SDDM)"
                echo "  -d, --dotfiles  Restore dotfiles only"
                echo "  -n, --niri      Restore Niri configuration only"
                echo "  -s, --sddm      Restore SDDM configuration only"
                echo "  -i, --install   Run Janus installation scripts"
                echo "  -h, --help      Show this help message"
                echo ""
                echo "No arguments: Interactive menu"
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
        exit 0
    fi
    
    # Interactive mode
    while true; do
        show_menu
        read -r choice
        
        case "$choice" in
            1)
                if confirm_action "restore all configurations"; then
                    backup_current_config
                    restore_dotfiles
                    restore_niri
                    restore_sddm
                    show_summary
                fi
                ;;
            2)
                if confirm_action "restore dotfiles"; then
                    backup_current_config
                    restore_dotfiles
                fi
                ;;
            3)
                if confirm_action "restore Niri configuration"; then
                    backup_current_config
                    restore_niri
                fi
                ;;
            4)
                if confirm_action "restore SDDM configuration"; then
                    restore_sddm
                fi
                ;;
            5)
                run_install_scripts
                ;;
            6)
                echo ""
                print_info "Backups will be created in: $HOME/.janus-backups/"
                print_info "Current restore would backup to: ${BACKUP_LOCATION}"
                echo ""
                ;;
            7)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option. Please select 1-7."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
