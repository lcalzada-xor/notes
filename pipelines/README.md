# Bug Bounty Automation Pipelines

> **Copy-paste ready workflows for modern reconnaissance and vulnerability scanning.**

This directory contains detailed, step-by-step guides (pipelines) designed to streamline your bug bounty workflow. Each file is written in Markdown but contains executable shell commands using industry-standard tools like **Nuclei**, **Dalfox**, **SQLMap**, **FFUF**, and **Amass**.

## 🔍 Reconnaissance Pipelines (`recon/`)

Focus on expanding your attack surface and discovering hidden assets.

- **[`subdomains.md`](recon/subdomains.md)**: Passive & Active enumeration, Permutations, DNS Resolution, and Visual Recon (BBOT, Amass, Subfinder).
- **[`urls.md`](recon/urls.md)**: URL discovery via Wayback/OINT, crawling (Katana), and parameter extraction.
- **[`ports.md`](recon/ports.md)**: Fast port scanning (Naabu) and service enumeration (Nmap).
- **[`cloud.md`](recon/cloud.md)**: Discovery of exposed S3 buckets, Azure blobs, and cloud assets.
- **[`js_analysis.md`](recon/js_analysis.md)**: JavaScript static analysis for secrets and endpoints.
- **[`fuzzing.md`](recon/fuzzing.md)**: Directory and parameter fuzzing with FFUF and Feroxbuster.

## 💥 Vulnerability Pipelines (`vulns/`)

Automated and semi-automated workflows for detecting specific vulnerability classes (OWASP Top 10).

- **[`nuclei/nuclei.md`](vulns/nuclei/nuclei.md)**: Advanced Nuclei usage, workflows, and custom templates.
- **[`xss/xss.md`](vulns/xss/xss.md)**: Cross-Site Scripting detection with **Dalfox** (WAF evasion, Blind XSS, DOM).
- **[`sqli/sqli.md`](vulns/sqli/sqli.md)**: SQL Injection detection with **SQLMap** and **Ghauri**.
- **[`ssrf/ssrf.md`](vulns/ssrf/ssrf.md)**: Server-Side Request Forgery testing (Cloud Metadata, OOB).
- **[`idor/idor.md`](vulns/idor/idor.md)**: Insecure Direct Object Reference testing (Autorize, Kiterunner).
- **[`lfi/lfi.md`](vulns/lfi/lfi.md)**: Local File Inclusion to RCE escalation.
- **[`auth_bypass/auth_bypass.md`](vulns/auth_bypass/auth_bypass.md)**: 403 Bypass and Authentication testing.
- **[`cve_scanning/cve_scanning.md`](vulns/cve_scanning/cve_scanning.md)**: Targeted CVE hunting.

## 🚀 How to Use

1.  **Initialize**: Use the `setup_audit.sh` script in the parent directory to create your project structure.
2.  **Select a Pipeline**: Choose the pipeline relevant to your current phase (e.g., `recon/subdomains.md`).
3.  **Execute**: Copy the commands, adjust the `TARGET` variable if needed, and run them.
4.  **Chain**: Output from one pipeline (e.g., `live_urls.txt`) feeds directly into the next (e.g., `nuclei`).
