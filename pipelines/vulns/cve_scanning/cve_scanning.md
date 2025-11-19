# CVE Scanning & Specific Exploit Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.

## 1. Identification
Identify technologies and versions to know which CVEs to look for.

```bash
# Wappalyzer / WhatWeb
whatweb -i live_urls.txt --log-verbose=scans/whatweb.txt

# Nuclei Tech Detection
nuclei -l live_urls.txt -t technologies/ -o scans/tech_stack.txt
```

## 2. CVE Hunting (Nuclei)
Scan for known CVEs associated with the identified tech.

```bash
# Scan for all critical/high CVEs
nuclei -l live_urls.txt -tags cve,critical,high -o scans/nuclei_cves.txt

# Scan for specific year (e.g., 2024)
nuclei -l live_urls.txt -tags cve2024 -o scans/nuclei_cve2024.txt
```

## 3. Exploit Verification
If a CVE is suspected, verify it with a specific PoC.

```bash
# Search for PoCs
searchsploit "Apache 2.4.49"

# Use specific Nuclei template
nuclei -u $TARGET -t cves/2021/CVE-2021-41773.yaml
```

## 4. SploitScan
Use automated tools to map exposed services to potential exploits.

```bash
# SploitScan (requires docker or python setup)
# sploitscan $TARGET
```
