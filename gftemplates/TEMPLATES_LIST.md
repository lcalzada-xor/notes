# Complete Templates List

Lista completa de todos los 73 templates disponibles con descripciones.

## Vulnerabilities (29 templates)

### Injection (9 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| sqli | `vulnerabilities/injection/sqli.json` | Detecta parametros susceptibles a SQL Injection |
| xss | `vulnerabilities/injection/xss.json` | Encuentra vectores de Cross-Site Scripting |
| ssrf | `vulnerabilities/injection/ssrf.json` | Identifica Server-Side Request Forgery |
| lfi | `vulnerabilities/injection/lfi.json` | Busca Local File Inclusion |
| rce | `vulnerabilities/injection/rce.json` | Detecta Remote Code Execution |
| xxe | `vulnerabilities/injection/xxe.json` | Encuentra XML External Entity |
| ssti | `vulnerabilities/injection/ssti.json` | Identifica Server-Side Template Injection |
| nosqli | `vulnerabilities/injection/nosqli.json` | Detecta NoSQL Injection |
| csti | `vulnerabilities/injection/csti.json` | Encuentra Client-Side Template Injection |

### Authentication & Authorization (6 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| jwt | `vulnerabilities/auth/jwt.json` | Detecta JWT tokens y vulnerabilidades |
| oauth | `vulnerabilities/auth/oauth.json` | Encuentra endpoints OAuth |
| idor | `vulnerabilities/auth/idor.json` | Identifica Insecure Direct Object Reference |
| session | `vulnerabilities/auth/session.json` | Detecta problemas de sesiones |
| broken-auth | `vulnerabilities/auth/broken-auth.json` | Encuentra endpoints de autenticacion |
| authz | `vulnerabilities/auth/authz.json` | Identifica problemas de autorizacion |

### Logic & Business (6 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| cors | `vulnerabilities/logic/cors.json` | Detecta CORS misconfigurations |
| redirect | `vulnerabilities/logic/redirect.json` | Encuentra Open Redirects |
| race-condition | `vulnerabilities/logic/race-condition.json` | Identifica Race Conditions |
| business-logic | `vulnerabilities/logic/business-logic.json` | Detecta fallas de logica de negocio |
| rate-limit | `vulnerabilities/logic/rate-limit.json` | Encuentra endpoints sin rate limiting |
| csrf | `vulnerabilities/logic/csrf.json` | Detecta Cross-Site Request Forgery |

### Modern Vulnerabilities (8 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| prototype-pollution | `vulnerabilities/modern/prototype-pollution.json` | Detecta Prototype Pollution |
| graphql | `vulnerabilities/modern/graphql.json` | Encuentra endpoints GraphQL |
| websocket | `vulnerabilities/modern/websocket.json` | Identifica conexiones WebSocket |
| api-abuse | `vulnerabilities/modern/api-abuse.json` | Detecta APIs internas o no documentadas |
| deserialization | `vulnerabilities/modern/deserialization.json` | Encuentra deserializacion insegura |
| path-traversal | `vulnerabilities/modern/path-traversal.json` | Detecta Path Traversal |
| crlf-injection | `vulnerabilities/modern/crlf-injection.json` | Identifica CRLF Injection |
| host-header | `vulnerabilities/modern/host-header.json` | Detecta Host Header Injection |

## Secrets (23 templates)

### Cloud Providers (5 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| aws-keys | `secrets/cloud/aws-keys.json` | Detecta AWS Access Keys y Secrets |
| gcp-keys | `secrets/cloud/gcp-keys.json` | Encuentra Google Cloud credentials |
| azure-keys | `secrets/cloud/azure-keys.json` | Detecta Azure keys y tokens |
| digitalocean | `secrets/cloud/digitalocean.json` | Encuentra DigitalOcean API tokens |
| heroku | `secrets/cloud/heroku.json` | Detecta Heroku API keys |

### SaaS & Third-Party (12 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| github-tokens | `secrets/saas/github-tokens.json` | Detecta GitHub personal access tokens |
| slack-tokens | `secrets/saas/slack-tokens.json` | Encuentra Slack tokens y webhooks |
| stripe-keys | `secrets/saas/stripe-keys.json` | Detecta Stripe API keys (live/test) |
| twilio | `secrets/saas/twilio.json` | Encuentra Twilio API credentials |
| sendgrid | `secrets/saas/sendgrid.json` | Detecta SendGrid API keys |
| mailgun | `secrets/saas/mailgun.json` | Encuentra Mailgun API keys |
| facebook | `secrets/saas/facebook.json` | Detecta Facebook access tokens |
| twitter | `secrets/saas/twitter.json` | Encuentra Twitter API keys |
| gitlab-tokens | `secrets/saas/gitlab-tokens.json` | Detecta GitLab access tokens |
| firebase | `secrets/saas/firebase.json` | Encuentra Firebase API keys |
| square | `secrets/saas/square.json` | Detecta Square API keys |
| paypal | `secrets/saas/paypal.json` | Encuentra PayPal credentials |

### Generic Secrets (6 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| api-keys | `secrets/generic/api-keys.json` | Detecta API keys genericas |
| credentials | `secrets/generic/credentials.json` | Encuentra usernames y passwords |
| private-keys | `secrets/generic/private-keys.json` | Detecta private keys SSH, RSA, etc. |
| tokens | `secrets/generic/tokens.json` | Encuentra tokens de autenticacion |
| env-vars | `secrets/generic/env-vars.json` | Detecta variables de entorno sensibles |
| certificates | `secrets/generic/certificates.json` | Encuentra certificados SSL/TLS |

## Recon (13 templates)

### Parameters (4 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| interesting-params | `recon/parameters/interesting-params.json` | Detecta parametros interesantes (debug, admin, etc.) |
| sensitive-params | `recon/parameters/sensitive-params.json` | Encuentra parametros sensibles (email, phone, etc.) |
| upload-params | `recon/parameters/upload-params.json` | Identifica parametros de upload |
| filter-params | `recon/parameters/filter-params.json` | Detecta parametros de filtrado y busqueda |

### Endpoints (5 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| api-endpoints | `recon/endpoints/api-endpoints.json` | Encuentra API endpoints (REST, GraphQL, etc.) |
| admin-panels | `recon/endpoints/admin-panels.json` | Detecta paneles de administracion |
| debug-endpoints | `recon/endpoints/debug-endpoints.json` | Identifica endpoints de debug |
| backup-files | `recon/endpoints/backup-files.json` | Encuentra archivos de backup |
| config-files | `recon/endpoints/config-files.json` | Detecta archivos de configuracion |

### Technologies (4 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| frameworks | `recon/technologies/frameworks.json` | Detecta frameworks web |
| javascript-files | `recon/technologies/javascript-files.json` | Encuentra archivos JavaScript |
| cms-detection | `recon/technologies/cms-detection.json` | Identifica CMS (WordPress, Drupal, etc.) |
| cdn-detection | `recon/technologies/cdn-detection.json` | Detecta CDNs utilizados |

## Data (7 templates)

### Serialization (3 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| json-endpoints | `data/serialization/json-endpoints.json` | Detecta endpoints JSON |
| xml-endpoints | `data/serialization/xml-endpoints.json` | Encuentra endpoints XML |
| yaml-files | `data/serialization/yaml-files.json` | Identifica archivos YAML |

### Encoding (4 templates)

| Template | Archivo | Descripcion |
|----------|---------|-------------|
| base64 | `data/encoding/base64.json` | Detecta strings en base64 |
| jwt-tokens | `data/encoding/jwt-tokens.json` | Encuentra JWT tokens |
| url-encoded | `data/encoding/url-encoded.json` | Identifica parametros URL-encoded |
| hex-encoded | `data/encoding/hex-encoded.json` | Detecta valores hexadecimales |

## Uso de Templates

```bash
# Sintaxis basica
cat file.txt | gf <template-name>

# Ejemplos
cat urls.txt | gf sqli
cat responses.txt | gf aws-keys
cat wayback.txt | gf api-endpoints
```

## Combinando Templates

```bash
# Multiples vulnerabilidades
cat urls.txt | gf sqli | gf xss | gf lfi

# Todos los secretos de cloud
cat files.txt | gf aws-keys | gf gcp-keys | gf azure-keys

# Pipeline completo
cat urls.txt | gf interesting-params | gf sqli | httpx -mc 200
```

## Ver Contenido de Template

```bash
# Ver patrones de un template
gf -dump sqli

# Ver donde esta instalado
ls ~/.gf/vulnerabilities/injection/
```

## Mas Informacion

- [README.md](README.md) - Documentacion completa
- [CHEATSHEET.md](CHEATSHEET.md) - Referencias rapidas
- [QUICKSTART.md](QUICKSTART.md) - Guia de inicio rapido
