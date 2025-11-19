# Nuclei Scanning Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.
> Example: `nuclei -u $(cat target)` or `nuclei -l live_urls.txt`

## 1. General Scan
Run a broad scan on all discovered URLs.

```bash
nuclei -l live_urls.txt -o scans/nuclei_general.txt
```

## 2. Workflows (Chained Scans)
Use workflows to automatically run specific templates when a technology is detected.

```bash
# Run all default workflows (e.g., if WordPress is found, run WP scans)
nuclei -l live_urls.txt -w workflows/ -o scans/nuclei_workflows.txt
```

## 3. Critical & High Only
Focus on high-impact vulnerabilities.

```bash
nuclei -l live_urls.txt -severity critical,high -o scans/nuclei_criticals.txt
```

## 4. New Templates
Scan for recently discovered vulnerabilities (last 30 days).

```bash
nuclei -l live_urls.txt -nt -o scans/nuclei_new_templates.txt
```

## 5. Custom Templates
Use your own or community-curated templates not in the default list.

```bash
# Load templates from a custom folder
nuclei -l live_urls.txt -t /path/to/custom-templates/ -o scans/nuclei_custom.txt
```

## 6. Vulnerability Specific
Scan for specific vulnerability classes.

```bash
# XSS, SQLi, SSRF, LFI
nuclei -l live_urls.txt -tags xss,sqli,ssrf,lfi -o scans/nuclei_vuln_specific.txt
```
