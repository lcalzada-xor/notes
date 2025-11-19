# JavaScript Analysis Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.

## 1. Collection
Gather all JavaScript files from the target.

```bash
# Get JS files from known URLs
cat live_urls.txt | grep "\.js$" > js_files.txt

# Subjs (Fetch JS from subdomains)
cat final_resolved_subs.txt | subjs >> js_files.txt
sort -u js_files.txt -o js_files_unique.txt
```

## 2. Secret Finding
Scan JS files for API keys, tokens, and credentials.

```bash
# SecretFinder
# Note: Requires python script
python3 SecretFinder.py -i https://target.com -o cli >> secrets.txt
# Or loop through your list
for url in $(cat js_files_unique.txt); do python3 SecretFinder.py -i $url -o cli >> scans/js_secrets.txt; done

# Mantra (Fast secret scanner)
cat js_files_unique.txt | mantra >> scans/mantra_secrets.txt

# Nuclei Exposures
nuclei -l js_files_unique.txt -tags exposure,token -o scans/nuclei_js_exposures.txt
```

## 3. Endpoint Extraction
Find new endpoints and hidden URLs within the JS code.

```bash
# LinkFinder
python3 linkfinder.py -i https://target.com/app.js -o cli

# Katana (already does this, but good to verify)
# katana -u ... -js-crawl ...
```

## 4. Vulnerability Scanning
Check for DOM XSS and other client-side issues.

```bash
# Nuclei Headless / DOM XSS
nuclei -l js_files_unique.txt -tags headless,xss -o scans/nuclei_js_vulns.txt
```
