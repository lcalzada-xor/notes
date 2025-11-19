#!/bin/bash

# setup_audit.sh
# Script to initialize a bug bounty audit environment with best practices.
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

create_pipeline_cheatsheet() {
    local dir="$1"
    # Remove the domain prefix to get the relative path (e.g., recon/subdomains)
    local folder_type=$(echo "$dir" | sed "s|^$CLEAN_DOMAIN/||")
    local pipeline_file="$dir/pipeline.md"
    local content=""

    case "$folder_type" in
        "recon/subdomains")
            content="# Subdomain Enumeration Pipeline
# Tools: subfinder, assetfinder, amass

# 1. Passive Enumeration
subfinder -d $CLEAN_DOMAIN -o subdomains_subfinder.txt
assetfinder -subs-only $CLEAN_DOMAIN > subdomains_assetfinder.txt
amass enum -passive -d $CLEAN_DOMAIN -o subdomains_amass.txt

# 2. Merge and Sort
cat subdomains_*.txt | sort -u > subdomains.txt

# 3. Live Host Discovery
cat subdomains.txt | httpx -silent -o live_hosts.txt
"
            ;;
        "recon/urls")
            content="# URL Discovery Pipeline
# Tools: waybackurls, gau, katana

# 1. Fetch from Archives
waybackurls $CLEAN_DOMAIN > urls_wayback.txt
gau $CLEAN_DOMAIN > urls_gau.txt

# 2. Active Crawling
katana -u https://$CLEAN_DOMAIN -d 5 -o urls_katana.txt

# 3. Merge and Sort
cat urls_*.txt | sort -u > all_urls.txt

# 4. Filter for interesting extensions
cat all_urls.txt | grep -E '\.js$|\.json$|\.php$|\.aspx$' > interesting_urls.txt
"
            ;;
        "recon/ports")
            content="# Port Scanning Pipeline
# Tools: naabu, nmap

# 1. Fast Port Scan (Naabu)
naabu -host $CLEAN_DOMAIN -p - -o open_ports.txt

# 2. Detailed Scan (Nmap) on found ports
# Note: Adjust input file as needed
nmap -sC -sV -iL live_hosts.txt -oN nmap_scan.txt
"
            ;;
        "recon/visual")
            content="# Visual Recon Pipeline
# Tools: aquatone or gowitness

# 1. Aquatone
cat ../subdomains/live_hosts.txt | aquatone -out screenshots

# OR

# 2. Gowitness
gowitness scan file -f ../subdomains/live_hosts.txt --screenshot-path ./screenshots
"
            ;;
        "recon/params")
            content="# Parameter Discovery Pipeline
# Tools: arjun, paramspider

# 1. ParamSpider
paramspider -d $CLEAN_DOMAIN -o params_spider.txt

# 2. Arjun
arjun -u https://$CLEAN_DOMAIN -oJ params_arjun.json
"
            ;;
        "vulns/sqli")
            content="# SQL Injection Pipeline
# Tools: sqlmap, ghauri, gf

# 1. Filter URLs for SQLi patterns
cat ../../recon/urls/all_urls.txt | gf sqli > potential_sqli.txt

# 2. Run Ghauri
ghauri -m potential_sqli.txt --batch --confirm --level 3

# 3. Run SQLMap
sqlmap -m potential_sqli.txt --batch --random-agent --level 1 --risk 1
"
            ;;
        "vulns/xss")
            content="# XSS Pipeline
# Tools: dalfox, kxss, gf

# 1. Filter URLs for XSS patterns
cat ../../recon/urls/all_urls.txt | gf xss > potential_xss.txt

# 2. Check with kxss (fast check for reflection)
cat potential_xss.txt | kxss > reflected_xss.txt

# 3. Verify with Dalfox
cat reflected_xss.txt | dalfox pipe -o verified_xss.txt
"
            ;;
        "vulns/ssrf")
            content="# SSRF Pipeline
# Tools: interactsh-client, collaborator

# 1. Filter URLs for SSRF patterns
cat ../../recon/urls/all_urls.txt | gf ssrf > potential_ssrf.txt

# 2. Manual/Automated Testing
# Replace parameters with your collaborator payload
# Example:
# qsreplace \"http://YOUR_COLLABORATOR_ID\" < potential_ssrf.txt | httpx -silent
"
            ;;
        "vulns/idor")
            content="# IDOR Pipeline
# Tools: Burp Suite (Autorize), Manual

# IDORs are hard to automate fully.
# 1. Identify ID-based parameters in URLs
cat ../../recon/urls/all_urls.txt | grep -E \"id=|user=|account=\" > potential_idors.txt

# 2. Use Burp Suite Autorize extension to test access controls.
"
            ;;
        "vulns/lfi")
            content="# LFI Pipeline
# Tools: gf, nuclei

# 1. Filter URLs for LFI patterns
cat ../../recon/urls/all_urls.txt | gf lfi > potential_lfi.txt

# 2. Fuzzing with Nuclei LFI templates
nuclei -l potential_lfi.txt -tags lfi -o lfi_results.txt
"
            ;;
        "vulns/auth_bypass")
            content="# Auth Bypass Pipeline
# Tools: Burp Suite (403 Bypasser), Manual

# 1. Identify 403/401 endpoints
cat ../../recon/urls/all_urls.txt | httpx -mc 401,403 -o restricted_urls.txt

# 2. Try bypass techniques (headers, methods, etc.)
# Example: X-Custom-IP-Authorization: 127.0.0.1
"
            ;;
        "vulns/nuclei")
            content="# Nuclei Pipeline
# Tools: nuclei

# 1. General Scan
nuclei -l ../../recon/subdomains/live_hosts.txt -o nuclei_results.txt

# 2. Critical/High Severity
nuclei -l ../../recon/subdomains/live_hosts.txt -s critical,high -o nuclei_critical.txt
"
            ;;
        "vulns/cve_scanning")
            content="# CVE Scanning Pipeline
# Tools: nuclei

# 1. Scan for specific CVEs (e.g., 2024)
nuclei -l ../../recon/subdomains/live_hosts.txt -tags cve2024 -o cve_results.txt
"
            ;;
    esac

    if [ -n "$content" ]; then
        if [ "$DRY_RUN" = true ]; then
             echo -e "${YELLOW}[DRY-RUN]${NC} Would create pipeline file '$pipeline_file'"
        else
             echo "$content" > "$pipeline_file"
             info "Created pipeline cheatsheet: $pipeline_file"
        fi
    fi
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
DIRS=(
    "$CLEAN_DOMAIN"
    "$CLEAN_DOMAIN/scope"
    "$CLEAN_DOMAIN/logs"
    "$CLEAN_DOMAIN/recon/subdomains"
    "$CLEAN_DOMAIN/recon/urls"
    "$CLEAN_DOMAIN/recon/ports"
    "$CLEAN_DOMAIN/recon/visual"
    "$CLEAN_DOMAIN/recon/params"
    "$CLEAN_DOMAIN/vulns/sqli"
    "$CLEAN_DOMAIN/vulns/xss"
    "$CLEAN_DOMAIN/vulns/ssrf"
    "$CLEAN_DOMAIN/vulns/idor"
    "$CLEAN_DOMAIN/vulns/lfi"
    "$CLEAN_DOMAIN/vulns/auth_bypass"
    "$CLEAN_DOMAIN/vulns/nuclei"
    "$CLEAN_DOMAIN/vulns/cve_scanning"
    "$CLEAN_DOMAIN/evidence"
    "$CLEAN_DOMAIN/scans"
)

for dir in "${DIRS[@]}"; do
    execute "Creating directory $dir" mkdir -p "$dir"
    create_pipeline_cheatsheet "$dir"
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

# Create scope files
SCOPE_FILE="$CLEAN_DOMAIN/scope/scope.txt"
OUT_SCOPE_FILE="$CLEAN_DOMAIN/scope/out_of_scope.txt"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY-RUN]${NC} Would create file '$SCOPE_FILE' (empty)"
    echo -e "${YELLOW}[DRY-RUN]${NC} Would create file '$OUT_SCOPE_FILE' (empty)"
else
    touch "$SCOPE_FILE"
    touch "$OUT_SCOPE_FILE"
    info "Created scope files in $CLEAN_DOMAIN/scope/"
fi

info "Audit environment setup complete for $CLEAN_DOMAIN"

if [ "$DRY_RUN" = false ]; then
    echo -e "\n${GREEN}Next steps:${NC}"
    echo -e "  cd $CLEAN_DOMAIN"
    echo -e "  # Check the pipeline.md files in each folder for command suggestions."
    echo -e "  # Add in-scope domains to scope/scope.txt"
fi
