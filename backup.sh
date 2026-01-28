#!/bin/bash

# Janus Arch Linux Backup Script
# Automates the process of creating backups and updating the repository

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JANUS_DIR="${BACKUP_DIR}/Janus-Arch-Linux"
DATE=$(date +%Y%m%d)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

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

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        print_error "Not a git repository!"
        exit 1
    fi
}

# Update Janus submodule
update_submodule() {
    print_info "Updating Janus-Arch-Linux submodule..."
    cd "${JANUS_DIR}"
    
    # Fetch latest changes
    git fetch origin
    
    # Show current and latest version
    CURRENT_COMMIT=$(git rev-parse --short HEAD)
    LATEST_COMMIT=$(git rev-parse --short origin/master)
    
    if [ "$CURRENT_COMMIT" = "$LATEST_COMMIT" ]; then
        print_success "Janus submodule is already up to date (${CURRENT_COMMIT})"
    else
        print_info "Updating from ${CURRENT_COMMIT} to ${LATEST_COMMIT}..."
        git pull origin master
        print_success "Janus submodule updated!"
    fi
    
    cd "${BACKUP_DIR}"
}

# Create compressed archive
create_archive() {
    print_info "Creating compressed archive..."
    
    ARCHIVE_NAME="janus-arch-linux-v${DATE}.tar.gz"
    
    if [ -f "${ARCHIVE_NAME}" ]; then
        print_warning "Archive ${ARCHIVE_NAME} already exists. Skipping..."
        return 0
    fi
    
    tar -czf "${ARCHIVE_NAME}" \
        --exclude='.git' \
        --exclude='*.log' \
        --exclude='*.tmp' \
        --exclude='.cache' \
        Janus-Arch-Linux/
    
    ARCHIVE_SIZE=$(du -h "${ARCHIVE_NAME}" | cut -f1)
    print_success "Archive created: ${ARCHIVE_NAME} (${ARCHIVE_SIZE})"
}

# Commit changes
commit_changes() {
    print_info "Checking for changes to commit..."
    
    if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        git add .
        
        # Get Janus version info
        cd "${JANUS_DIR}"
        JANUS_VERSION=$(git describe --tags 2>/dev/null || git rev-parse --short HEAD)
        cd "${BACKUP_DIR}"
        
        git commit -m "Backup: Update to Janus ${JANUS_VERSION} - ${TIMESTAMP}"
        print_success "Changes committed"
        return 0
    else
        print_info "No changes to commit"
        return 1
    fi
}

# Push to remote
push_to_remote() {
    print_info "Pushing to remote repository..."
    
    if git push; then
        print_success "Successfully pushed to remote!"
    else
        print_error "Failed to push to remote"
        exit 1
    fi
}

# Show status
show_status() {
    print_info "Repository Status:"
    echo ""
    git status --short
    echo ""
    
    print_info "Recent Commits:"
    git log --oneline -5
    echo ""
    
    print_info "Backup Archives:"
    ls -lh *.tar.gz 2>/dev/null | awk '{print $9, "(" $5 ")"}'
    echo ""
}

# Main menu
show_menu() {
    echo ""
    echo "=================================="
    echo "  Janus Backup Manager"
    echo "=================================="
    echo "1. Full backup (update + archive + commit + push)"
    echo "2. Update submodule only"
    echo "3. Create archive only"
    echo "4. Commit and push changes"
    echo "5. Show status"
    echo "6. Exit"
    echo "=================================="
    echo -n "Select an option [1-6]: "
}

# Main script
main() {
    cd "${BACKUP_DIR}"
    check_git_repo
    
    # If arguments provided, run non-interactive mode
    if [ $# -gt 0 ]; then
        case "$1" in
            --full|-f)
                print_info "Running full backup..."
                update_submodule
                create_archive
                if commit_changes; then
                    push_to_remote
                fi
                print_success "Full backup complete!"
                ;;
            --update|-u)
                update_submodule
                ;;
            --archive|-a)
                create_archive
                ;;
            --commit|-c)
                if commit_changes; then
                    push_to_remote
                fi
                ;;
            --status|-s)
                show_status
                ;;
            --help|-h)
                echo "Usage: $0 [OPTION]"
                echo ""
                echo "Options:"
                echo "  -f, --full      Full backup (update + archive + commit + push)"
                echo "  -u, --update    Update Janus submodule only"
                echo "  -a, --archive   Create compressed archive only"
                echo "  -c, --commit    Commit and push changes"
                echo "  -s, --status    Show repository status"
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
                print_info "Running full backup..."
                update_submodule
                create_archive
                if commit_changes; then
                    push_to_remote
                fi
                print_success "Full backup complete!"
                ;;
            2)
                update_submodule
                ;;
            3)
                create_archive
                ;;
            4)
                if commit_changes; then
                    push_to_remote
                fi
                ;;
            5)
                show_status
                ;;
            6)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option. Please select 1-6."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"
