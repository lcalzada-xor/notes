#!/bin/bash

# setup_audit.sh
# Script to initialize a bug bounty audit environment.
# Usage: ./setup_audit.sh <target-domain-or-url> [--verbose] [--dry-run]

set -euo pipefail

# --- Configuration ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

VERBOSE=false
DRY_RUN=false
TARGET_INPUT=""

# --- Functions ---

log() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${BLUE}[${timestamp}]${NC} ${level} ${message}"
}

info() {
    log "${GREEN}[INFO]${NC}" "$1"
}

warn() {
    log "${YELLOW}[WARN]${NC}" "$1"
}

error() {
    log "${RED}[ERROR]${NC}" "$1"
    exit 1
}

debug() {
    if [ "$VERBOSE" = true ]; then
        log "${BLUE}[DEBUG]${NC}" "$1"
    fi
}

usage() {
    echo -e "Usage: $0 <target> [options]"
    echo -e "Options:"
    echo -e "  --verbose    Enable verbose output"
    echo -e "  --dry-run    Show what would be done without making changes"
    echo -e "  -h, --help   Show this help message"
    exit 1
}

# --- Argument Parsing ---

if [ $# -eq 0 ]; then
    usage
fi

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --verbose)
            VERBOSE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [ -z "$TARGET_INPUT" ]; then
                TARGET_INPUT="$1"
            else
                error "Unknown argument or multiple targets specified: $1"
            fi
            shift
            ;;
    esac
done

if [ -z "$TARGET_INPUT" ]; then
    error "No target specified."
fi

# --- Validation & Normalization ---

info "Validating target: $TARGET_INPUT"

# Normalize URL (ensure scheme exists)
if [[ "$TARGET_INPUT" =~ ^http[s]?:// ]]; then
    TARGET_URL="$TARGET_INPUT"
else
    TARGET_URL="https://$TARGET_INPUT"
    debug "Added scheme: $TARGET_URL"
fi

# Extract clean domain for folder name
# Remove protocol
CLEAN_DOMAIN=$(echo "$TARGET_URL" | sed -E 's|^\w+://||')
# Remove path, query, fragment
CLEAN_DOMAIN=$(echo "$CLEAN_DOMAIN" | cut -d'/' -f1 | cut -d'?' -f1 | cut -d'#' -f1)
# Remove port if present
CLEAN_DOMAIN=$(echo "$CLEAN_DOMAIN" | cut -d':' -f1)

if [ -z "$CLEAN_DOMAIN" ]; then
    error "Could not extract a valid domain from input."
fi

info "Target URL: $TARGET_URL"
info "Project Folder: $CLEAN_DOMAIN"

# --- Execution ---

execute() {
    local cmd_desc="$1"
    shift
    local cmd=("$@")

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} Would execute: ${cmd[*]}"
    else
        debug "Executing: ${cmd[*]}"
        "${cmd[@]}"
    fi
}

# Check if directory exists
if [ -d "$CLEAN_DOMAIN" ] && [ "$DRY_RUN" = false ]; then
    warn "Directory '$CLEAN_DOMAIN' already exists."
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Aborting."
        exit 0
    fi
fi

info "Creating directory structure..."

# Create directories
DIRS=("$CLEAN_DOMAIN" "$CLEAN_DOMAIN/recon" "$CLEAN_DOMAIN/vulns" "$CLEAN_DOMAIN/evidence" "$CLEAN_DOMAIN/scans" "$CLEAN_DOMAIN/vulns/sqli" "$CLEAN_DOMAIN/vulns/xss" "$CLEAN_DOMAIN/vulns/ssrf" "$CLEAN_DOMAIN/vulns/idor" "$CLEAN_DOMAIN/vulns/lfi" "$CLEAN_DOMAIN/vulns/auth_bypass" "$CLEAN_DOMAIN/vulns/nuclei" "$CLEAN_DOMAIN/vulns/cve_scanning")

for dir in "${DIRS[@]}"; do
    execute "Creating directory $dir" mkdir -p "$dir"
done

# Set permissions (700 for privacy)
execute "Setting permissions" chmod 700 "$CLEAN_DOMAIN"

# Create target file
TARGET_FILE="$CLEAN_DOMAIN/target"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY-RUN]${NC} Would create file '$TARGET_FILE' with content: $TARGET_URL"
else
    echo "$TARGET_URL" > "$TARGET_FILE"
    info "Created target file: $TARGET_FILE"
fi

info "Audit environment setup complete for $CLEAN_DOMAIN"
if [ "$DRY_RUN" = false ]; then
    echo -e "\n${GREEN}Next steps:${NC}"
    echo -e "  cd $CLEAN_DOMAIN"
    echo -e "  # Example: Run subdomain enumeration"
    echo -e "  subfinder -d \$(cat target | sed 's|https://||') -o recon/subs.txt"
fi
