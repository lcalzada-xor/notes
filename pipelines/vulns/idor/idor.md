# IDOR (Insecure Direct Object Reference) Pipeline

> **Tip:** IDORs are logic bugs and hard to fully automate. Semi-automation is key.

## 1. Parameter Identification
Find URLs with numeric IDs or UUIDs.

```bash
# GF Patterns
gf idor < live_urls.txt > idor_candidates.txt

# Grep for common ID parameters
grep -E "id=|user=|account=|order=|profile=" live_urls.txt > idor_params.txt
```

## 2. Burp Suite Automation (Autorize)
This is the most effective method.
1. Install **Autorize** extension in Burp Suite.
2. Login as **User A** and capture the cookie/token.
3. Configure Autorize with **User B**'s cookie/token (or no auth for unauthenticated testing).
4. Browse the app as **User A**.
5. Autorize will replay requests as **User B** and highlight differences in length/status.

## 3. Kiterunner (API IDORs)
If targeting APIs, use Kiterunner to find endpoints and then fuzz IDs.

```bash
# Scan for routes
kr scan $TARGET -w routes-large.kite -o scans/kiterunner_results.json

# Fuzz IDs on found endpoints (Manual/Scripted)
# Replace {id} with a list of IDs
ffuf -u $TARGET/api/users/FUZZ -w ids.txt -mc 200
```

## 4. Nuclei IDOR Templates
Scan for common IDOR patterns.

```bash
nuclei -l live_urls.txt -tags idor -o scans/nuclei_idor.txt
```
