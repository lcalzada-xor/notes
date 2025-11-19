# Bug Bounty Pipelines

This directory contains executable workflows and command sequences for various stages of a bug bounty engagement.

## Directory Structure

### `recon/`
Pipelines focused on asset discovery and surface area expansion.
- **`subdomains.md`**: Workflow for finding, resolving, and probing subdomains.
- **`urls.md`**: Workflow for gathering URLs from passive sources and active crawling, then filtering them.

### `vulns/`
Pipelines focused on identifying specific vulnerabilities.
- **`nuclei/`**: Workflows for using Nuclei effectively.
- **`sqli/`**: SQL Injection detection and exploitation.
- **`idor/`**: Insecure Direct Object Reference testing.
- **`lfi/`**: Local File Inclusion and RCE escalation.
- **`auth_bypass/`**: Authentication bypass and 403 evasion.
- **`cve_scanning/`**: Specific CVE hunting.
- **`ssrf/`**: Server-Side Request Forgery.
- **`xss/`**: Cross-Site Scripting.

## How to Use

These files are written in Markdown but contain shell commands. You can:
1. Copy-paste commands into your terminal.
2. Use them as a reference to build your own automation scripts.
3. Adapt the flags and wordlists to your specific target.
