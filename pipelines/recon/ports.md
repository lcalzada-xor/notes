# Port Scanning & Service Discovery Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.
> Example: `export TARGET=$(cat target | sed 's|https://||')`

## 1. Fast Port Scanning (Naabu)
Quickly identify open ports across all resolved subdomains.

```bash
# Scan all ports on found subdomains
naabu -list final_resolved_subs.txt -p - -rate 1000 -silent -o open_ports.txt
```

## 2. Service Enumeration (Nmap)
Identify services and versions on the found ports.

```bash
# Extract IP:Port pairs or just IPs to scan
cat open_ports.txt | cut -d ":" -f 1 | sort -u > live_ips.txt

# Comprehensive scan (Service Version, Default Scripts)
# Note: This can be slow. Adjust -T4 or --min-rate if needed.
nmap -sC -sV -iL live_ips.txt -oA scans/nmap_full
```

## 3. Targeted Service Scanning
If you find specific interesting ports, scan them individually.

```bash
# Example: Check for anonymous FTP
nmap -p 21 --script ftp-anon -iL live_ips.txt

# Example: Check for SMB vulnerabilities
nmap -p 445 --script smb-vuln* -iL live_ips.txt
```

## 4. Visual Inspection (HTTP Ports)
If non-standard HTTP ports are found (e.g., 8080, 8443, 3000), feed them back into your web probing pipeline.

```bash
cat open_ports.txt | httpx -silent -title -tech-detect -o live_ports_web.txt
```
