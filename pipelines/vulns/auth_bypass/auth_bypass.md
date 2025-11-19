# Auth Bypass & 403 Evasion Pipeline

> **Tip:** Use `setup_audit.sh` to generate the `target` file.

## 1. 403/401 Evasion
Try to bypass access restrictions on forbidden endpoints.

```bash
# DontGo403
dontgo403 -u $TARGET/admin

# Byp4xx
byp4xx $TARGET/admin

# Nuclei Misconfiguration Templates
nuclei -u $TARGET/admin -tags misconfig,exposure -o scans/nuclei_bypass.txt
```

## 2. Header Manipulation
Test if access control relies on specific headers.

```bash
# Common headers to fuzz
X-Forwarded-For: 127.0.0.1
X-Originating-IP: 127.0.0.1
X-Remote-IP: 127.0.0.1
Referer: $TARGET
```

## 3. API Auth Bypass
Check for common API flaws.

- **Method Flipping**: Change `GET` to `POST`, `PUT`, `DELETE`.
- **Content-Type**: Change `application/json` to `application/xml` or `text/plain`.
- **Version Downgrade**: `/api/v2/users` -> `/api/v1/users`.

## 4. Logic Flaws (Manual)
- **Response Manipulation**: Intercept response and change `{"role": "user"}` to `{"role": "admin"}`.
- **Status Code Manipulation**: Change `403 Forbidden` to `200 OK` in response (sometimes works on client-side checks).
