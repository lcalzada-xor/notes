# Content Discovery (Fuzzing) Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.
> Example: `export TARGET=$(cat target)`

## 1. Directory & File Fuzzing (FFUF)
Brute-force directories and files to find hidden content.

```bash
# Basic Directory Fuzzing
# Replace wordlist with your preferred SecLists path
ffuf -u $TARGET/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -mc 200,301,302,403 -fc 404 -o scans/ffuf_dirs.json

# File Extension Fuzzing
ffuf -u $TARGET/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt -e .php,.html,.js,.json,.bak,.zip -mc 200 -o scans/ffuf_files.json
```

## 2. Recursive Scanning (Feroxbuster)
Fast, recursive scanning to map the entire application structure.

```bash
# Feroxbuster (Auto-tunes threads, recursive by default)
feroxbuster -u $TARGET -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -t 50 --depth 2 --extract-links --json -o scans/ferox_results.json
```

## 3. Virtual Host Fuzzing
Find hidden vhosts that might not be in public DNS.

```bash
# FFUF VHost
ffuf -u $TARGET -H "Host: FUZZ.target.com" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -mc 200 -fs <size-of-default-response>
```

## 4. Parameter Fuzzing
Find hidden parameters on interesting endpoints.

```bash
# Arjun (Targeted)
arjun -u $TARGET/endpoint -o scans/arjun_params.json

# FFUF (Brute-force)
ffuf -u $TARGET/endpoint?FUZZ=test -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt -fs <size-of-error>
```
