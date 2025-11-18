# Secrets & API Keys Templates

Templates para detectar secretos, API keys, tokens y credentials expuestos.

## Categorias

### Cloud Providers (5 templates)

Credenciales de proveedores de servicios en la nube.

- **aws-keys.json**: AWS Access Keys - Detecta AWS Access Key ID y Secret Access Keys
- **gcp-keys.json**: Google Cloud Keys - Encuentra API keys y service accounts de GCP
- **azure-keys.json**: Azure Keys - Detecta credenciales de Azure
- **digitalocean.json**: DigitalOcean Tokens - Encuentra tokens de DigitalOcean
- **heroku.json**: Heroku API Keys - Detecta API keys de Heroku

### SaaS & Third-Party (12 templates)

Tokens y keys de servicios SaaS populares.

- **github-tokens.json**: GitHub Tokens - Detecta todos los tipos de tokens de GitHub
- **slack-tokens.json**: Slack Tokens - Encuentra tokens y webhooks de Slack
- **stripe-keys.json**: Stripe API Keys - Detecta keys live y test de Stripe
- **twilio.json**: Twilio API Keys - Encuentra credentials de Twilio
- **sendgrid.json**: SendGrid API Keys - Detecta API keys de SendGrid
- **mailgun.json**: Mailgun API Keys - Encuentra keys de Mailgun
- **facebook.json**: Facebook Tokens - Detecta access tokens de Facebook
- **twitter.json**: Twitter API Keys - Encuentra credentials de Twitter/X
- **gitlab-tokens.json**: GitLab Tokens - Detecta personal access tokens de GitLab
- **firebase.json**: Firebase Keys - Encuentra API keys de Firebase
- **square.json**: Square API Keys - Detecta credentials de Square
- **paypal.json**: PayPal Keys - Encuentra client IDs y secrets de PayPal

### Generic Secrets (6 templates)

Patrones genericos de secretos y credentials.

- **api-keys.json**: Generic API Keys - Detecta API keys genericas
- **credentials.json**: Usernames & Passwords - Encuentra credentials hardcodeadas
- **private-keys.json**: Private Keys - Detecta claves privadas SSH, RSA, etc.
- **tokens.json**: Generic Tokens - Encuentra tokens genericos de autenticacion
- **env-vars.json**: Environment Variables - Detecta archivos .env y variables sensibles
- **certificates.json**: SSL Certificates - Encuentra certificados SSL/TLS

## Uso

### Escaneo basico

```bash
# Buscar AWS keys
cat files.txt | gf aws-keys

# Buscar GitHub tokens
cat code.js | gf github-tokens

# Buscar API keys genericas
cat config.json | gf api-keys
```

### Escaneo masivo

```bash
# Escanear todos los secretos de cloud
cat responses.txt | gf aws-keys | gf gcp-keys | gf azure-keys

# Escanear todos los secretos SaaS
cat jsfiles.txt | gf github-tokens | gf slack-tokens | gf stripe-keys

# Escanear repositorio completo
find . -type f | while read file; do
    cat "$file" | gf aws-keys | gf github-tokens | gf api-keys
done
```

### Con JavaScript files

```bash
# Extraer y escanear todos los JS
cat urls.txt | gf javascript-files | while read js_url; do
    curl -s "$js_url" | gf aws-keys | gf github-tokens | gf stripe-keys
done
```

### Con GitHub/GitLab

```bash
# Clonar y escanear repositorio
git clone https://github.com/target/repo.git temp
cd temp
find . -type f -exec cat {} \\; | gf aws-keys > ../secrets.txt
find . -type f -exec cat {} \\; | gf github-tokens >> ../secrets.txt
cd .. && rm -rf temp
```

### Con Wayback Machine

```bash
# Escanear archivos historicos
cat domains.txt | waybackurls | grep -E "\\.(js|json|xml|txt|env)$" |
while read url; do
    curl -s "$url" | gf aws-keys | gf api-keys
done
```

## Validacion de Secretos

### AWS Keys

```bash
# Validar AWS keys encontradas
aws sts get-caller-identity --aws-access-key-id AKIA... --aws-secret-access-key ...
```

### GitHub Tokens

```bash
# Validar GitHub token
curl -H "Authorization: token ghp_..." https://api.github.com/user
```

### Slack Tokens

```bash
# Validar Slack token
curl -X POST https://slack.com/api/auth.test -d token=xoxb-...
```

### Stripe Keys

```bash
# Validar Stripe key
curl https://api.stripe.com/v1/charges -u sk_live_...:
```

## Severidad y Impacto

### Critico
- AWS Keys con permisos amplios
- GCP Service Account Keys
- Database credentials con acceso produccion
- Private keys sin password

### Alto
- GitHub tokens con acceso a repos privados
- Stripe live keys
- Twilio credentials
- PayPal production keys

### Medio
- API keys de servicios de terceros
- Tokens de test/staging
- Slack webhooks
- Firebase keys

### Bajo
- Tokens expirados
- Keys de servicios gratuitos
- Public API keys sin privilegios

## Tips Importantes

1. **Siempre valida**: No todos los matches son reales, valida cada secreto
2. **Reporta responsablemente**: Usa programas de bug bounty o disclosure responsable
3. **No expongas secretos**: No publiques secretos reales en reportes
4. **Busca en multiples fuentes**: JS files, config files, error messages, logs
5. **Busca historico**: Usa wayback machine y git history
6. **Automatiza**: Integra en tu pipeline de recon

## Reportando Secretos

### Que incluir en el reporte

1. Tipo de secreto encontrado
2. Donde se encontro (URL, archivo, linea)
3. Validacion (sin exponer el secreto completo)
4. Impacto potencial
5. Recomendaciones de remediacion

### Ejemplo de reporte

```markdown
## Secret Exposure - AWS Access Keys

**Severity**: Critical

**Description**:
AWS Access Keys found exposed in JavaScript file

**Location**:
https://target.com/static/js/app.bundle.js

**Evidence**:
Found AWS credentials starting with AKIA...
The credentials were validated and have access to S3 buckets

**Impact**:
Attacker could access sensitive data in S3 buckets

**Recommendation**:
1. Rotate the exposed credentials immediately
2. Move credentials to environment variables
3. Implement secrets scanning in CI/CD
4. Review access logs for unauthorized access
```

## False Positives

Algunos patrones comunes de false positives:

- Ejemplos en documentacion
- Placeholders o templates
- Keys de test hardcodeadas conocidas
- Keys en comentarios de codigo
- Strings que parecen keys pero no lo son

Siempre valida antes de reportar!
