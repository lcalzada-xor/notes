# GF Templates Collection for Bug Bounty

Una coleccion completa y organizada de templates GF (Grep Format) para bug bounty hunting y pruebas de seguridad. Esta coleccion incluye mas de 60 templates especializados para detectar vulnerabilidades, secretos, APIs, y configuraciones inseguras.

## Que es GF?

GF es una herramienta creada por [tomnomnom](https://github.com/tomnomnom/gf) que actua como wrapper de grep, permitiendo definir patrones de busqueda complejos en archivos JSON y reutilizarlos facilmente con un nombre amigable.

## Instalacion

### 1. Instalar GF

```bash
go install github.com/tomnomnom/gf@latest
```

### 2. Configurar el directorio de templates

```bash
# Crear directorio de configuracion
mkdir -p ~/.gf

# Clonar este repositorio
git clone https://github.com/yourusername/gf-templates.git

# Copiar templates a ~/.gf
cp -r gf-templates/* ~/.gf/
```

### 3. Verificar instalacion

```bash
gf -list
```

## Estructura del Repositorio

```
gftemplates/
├── vulnerabilities/          # Vulnerabilidades web
│   ├── injection/           # SQLi, XSS, SSRF, LFI, RCE, XXE, SSTI, NoSQLi, CSTI
│   ├── auth/                # JWT, OAuth, IDOR, Session, Broken Auth, AuthZ
│   ├── logic/               # CORS, Redirect, Race Condition, Business Logic, Rate Limit, CSRF
│   └── modern/              # Prototype Pollution, GraphQL, WebSocket, API Abuse, etc.
├── secrets/                 # API keys, tokens, credentials
│   ├── cloud/              # AWS, GCP, Azure, DigitalOcean, Heroku
│   ├── saas/               # GitHub, Slack, Stripe, Twilio, SendGrid, etc.
│   └── generic/            # API Keys, Credentials, Private Keys, Tokens, etc.
├── recon/                   # Reconocimiento
│   ├── parameters/         # Parametros interesantes y sensibles
│   ├── endpoints/          # APIs, Admin panels, Debug, Backups, Config
│   └── technologies/       # Frameworks, JS files, CMS, CDN
└── data/                    # Formatos y encoding
    ├── serialization/      # JSON, XML, YAML
    └── encoding/           # Base64, JWT, URL-encoded, Hex
```

## Templates Disponibles

### Vulnerabilidades Web (24 templates)

#### Injection (9 templates)
- `sqli.json` - SQL Injection
- `xss.json` - Cross-Site Scripting
- `ssrf.json` - Server-Side Request Forgery
- `lfi.json` - Local File Inclusion
- `rce.json` - Remote Code Execution
- `xxe.json` - XML External Entity
- `ssti.json` - Server-Side Template Injection
- `nosqli.json` - NoSQL Injection
- `csti.json` - Client-Side Template Injection

#### Authentication & Authorization (6 templates)
- `jwt.json` - JWT Vulnerabilities
- `oauth.json` - OAuth Issues
- `idor.json` - Insecure Direct Object Reference
- `session.json` - Session Management
- `broken-auth.json` - Broken Authentication
- `authz.json` - Authorization Issues

#### Logic & Business (6 templates)
- `cors.json` - CORS Misconfigurations
- `redirect.json` - Open Redirects
- `race-condition.json` - Race Conditions
- `business-logic.json` - Business Logic Flaws
- `rate-limit.json` - Rate Limiting Issues
- `csrf.json` - Cross-Site Request Forgery

#### Modern Vulnerabilities (8 templates)
- `prototype-pollution.json` - Prototype Pollution
- `graphql.json` - GraphQL Security
- `websocket.json` - WebSocket Issues
- `api-abuse.json` - API Abuse
- `deserialization.json` - Insecure Deserialization
- `path-traversal.json` - Path Traversal
- `crlf-injection.json` - CRLF Injection
- `host-header.json` - Host Header Injection

### Secretos y API Keys (23 templates)

#### Cloud Providers (5 templates)
- `aws-keys.json` - AWS Access Keys
- `gcp-keys.json` - Google Cloud Keys
- `azure-keys.json` - Azure Keys
- `digitalocean.json` - DigitalOcean Tokens
- `heroku.json` - Heroku API Keys

#### SaaS & Third-Party (12 templates)
- `github-tokens.json` - GitHub Tokens
- `slack-tokens.json` - Slack Tokens
- `stripe-keys.json` - Stripe API Keys
- `twilio.json` - Twilio API Keys
- `sendgrid.json` - SendGrid API Keys
- `mailgun.json` - Mailgun API Keys
- `facebook.json` - Facebook Tokens
- `twitter.json` - Twitter API Keys
- `gitlab-tokens.json` - GitLab Tokens
- `firebase.json` - Firebase Keys
- `square.json` - Square API Keys
- `paypal.json` - PayPal Keys

#### Generic Secrets (6 templates)
- `api-keys.json` - Generic API Keys
- `credentials.json` - Usernames & Passwords
- `private-keys.json` - Private Keys & Certificates
- `tokens.json` - Generic Tokens
- `env-vars.json` - Environment Variables
- `certificates.json` - SSL Certificates

### Reconocimiento (13 templates)

#### Parameters (4 templates)
- `interesting-params.json` - Parametros interesantes
- `sensitive-params.json` - Parametros sensibles
- `upload-params.json` - Parametros de upload
- `filter-params.json` - Parametros de filtrado

#### Endpoints (5 templates)
- `api-endpoints.json` - API Endpoints
- `admin-panels.json` - Paneles de administracion
- `debug-endpoints.json` - Endpoints de debug
- `backup-files.json` - Archivos de backup
- `config-files.json` - Archivos de configuracion

#### Technologies (4 templates)
- `frameworks.json` - Deteccion de frameworks
- `javascript-files.json` - Archivos JavaScript
- `cms-detection.json` - Deteccion de CMS
- `cdn-detection.json` - Deteccion de CDN

### Datos y Encoding (7 templates)

#### Serialization (3 templates)
- `json-endpoints.json` - JSON Endpoints
- `xml-endpoints.json` - XML Endpoints
- `yaml-files.json` - YAML Files

#### Encoding (4 templates)
- `base64.json` - Base64 Encoding
- `jwt-tokens.json` - JWT Tokens
- `url-encoded.json` - URL Encoding
- `hex-encoded.json` - Hex Encoding

## Uso Basico

### Ejemplos Simples

```bash
# Buscar parametros susceptibles a SQLi
cat urls.txt | gf sqli

# Buscar tokens de AWS
cat response.txt | gf aws-keys

# Buscar endpoints de API
cat wayback_urls.txt | gf api-endpoints

# Buscar parametros IDOR
cat urls.txt | gf idor
```

### Combinando Patrones

```bash
# Buscar multiples vulnerabilidades
cat urls.txt | gf sqli | gf xss | gf lfi

# Buscar todos los secretos
cat files.txt | gf aws-keys | gf github-tokens | gf stripe-keys

# Pipeline completo
cat domains.txt | subfinder | httpx | katana | gf sqli | nuclei -t sqli
```

### Uso Avanzado

```bash
# Con contexto (lineas antes y despues)
cat file.txt | gf -A 2 -B 2 xss

# Case sensitive
cat urls.txt | grep -v "(?i)" | gf sqli

# Guardar resultados
cat urls.txt | gf ssrf > ssrf_targets.txt

# Multiples dominios
cat domains.txt | while read domain; do
    echo $domain | waybackurls | gf xss | qsreplace '"><script>alert(1)</script>' |
    while read url; do
        curl -s "$url" | grep -q "alert(1)" && echo "[XSS] $url"
    done
done
```

## Workflows Recomendados

### 1. Workflow Completo de Reconocimiento

```bash
#!/bin/bash
domain=$1

# Subdomain enumeration
echo "[+] Enumerando subdominios..."
subfinder -d $domain -silent | httpx -silent | tee subs.txt

# URL discovery
echo "[+] Descubriendo URLs..."
cat subs.txt | waybackurls | tee urls.txt
cat subs.txt | katana -silent | tee -a urls.txt

# Parameter analysis
echo "[+] Analizando parametros..."
cat urls.txt | gf interesting-params | tee interesting.txt
cat urls.txt | gf sensitive-params | tee sensitive.txt

# Vulnerability scanning
echo "[+] Buscando vulnerabilidades..."
cat urls.txt | gf sqli | tee sqli.txt
cat urls.txt | gf xss | tee xss.txt
cat urls.txt | gf ssrf | tee ssrf.txt
cat urls.txt | gf lfi | tee lfi.txt

# Secret scanning
echo "[+] Buscando secretos..."
cat urls.txt | gf aws-keys | tee secrets_aws.txt
cat urls.txt | gf github-tokens | tee secrets_github.txt

echo "[+] Reconocimiento completado!"
```

### 2. Workflow de SQLi

```bash
# Encontrar parametros SQLi y testear
cat urls.txt | gf sqli | qsreplace "FUZZ" |
while read url; do
    sqlmap -u "$url" --batch --level 2 --risk 2
done
```

### 3. Workflow de XSS

```bash
# Encontrar parametros XSS y testear
cat urls.txt | gf xss |
qsreplace '"><script>alert(document.domain)</script>' |
while read url; do
    echo $url | dalfox pipe
done
```

### 4. Workflow de SSRF

```bash
# Setup interactsh
interactsh-client &
INTERACTSH_URL=$(interactsh-client -n 1)

# Testear SSRF
cat urls.txt | gf ssrf |
qsreplace "http://$INTERACTSH_URL" |
while read url; do
    curl -s "$url" &
done

# Esperar interacciones
sleep 30
```

### 5. Workflow de Secretos

```bash
#!/bin/bash
# Escanear multiples fuentes de secretos

# GitHub
cat repos.txt | while read repo; do
    git clone $repo temp_repo
    cd temp_repo
    cat $(find . -type f) | gf aws-keys | tee -a ../secrets.txt
    cat $(find . -type f) | gf github-tokens | tee -a ../secrets.txt
    cd ..
    rm -rf temp_repo
done

# Archivos JS
cat urls.txt | gf javascript-files |
while read js_url; do
    curl -s $js_url | gf api-keys | tee -a secrets.txt
done

# Wayback Machine
cat domains.txt | waybackurls | gf aws-keys | tee -a secrets.txt
```

## Integracion con Otras Herramientas

### Con Nuclei

```bash
cat urls.txt | gf sqli | nuclei -t ~/nuclei-templates/vulnerabilities/sqli/
cat urls.txt | gf xss | nuclei -t ~/nuclei-templates/vulnerabilities/xss/
```

### Con HTTPX

```bash
cat urls.txt | gf api-endpoints | httpx -silent -mc 200 -json
```

### Con Dalfox

```bash
cat urls.txt | gf xss | dalfox pipe --skip-bav
```

### Con FFUF

```bash
cat urls.txt | gf upload-params |
while read url; do
    ffuf -u "$url" -w files.txt -mc 200
done
```

## Personalizacion

### Crear tu propio template

Crea un archivo JSON en `~/.gf/custom/`:

```json
{
  "flags": "-HnriE",
  "patterns": [
    "[?&](mi_param|otro_param)=",
    "/mi-endpoint-custom/",
    "patron-regex-personalizado"
  ]
}
```

### Modificar templates existentes

Simplemente edita el archivo JSON correspondiente en `~/.gf/`:

```bash
vim ~/.gf/vulnerabilities/injection/sqli.json
```

## Tips y Best Practices

1. **Combina multiples templates**: No uses solo un template, combina varios para cobertura completa
2. **Usa con pipelines**: GF es mas poderoso cuando se usa en pipelines con otras herramientas
3. **Personaliza para tu target**: Ajusta los templates segun las tecnologias del objetivo
4. **Valida los resultados**: GF encuentra candidatos, siempre valida manualmente
5. **Mantente actualizado**: Actualiza regularmente los templates con nuevos patrones
6. **Context matters**: Usa flags -A, -B, -C para ver contexto alrededor de matches
7. **Guarda tus resultados**: Siempre guarda los outputs para analisis posterior

## Flags Comunes de GF

```
-H    Mostrar nombre de archivo en resultados
-n    Mostrar numeros de linea
-r    Busqueda recursiva en directorios
-i    Case-insensitive (ignora mayusculas/minusculas)
-o    Solo mostrar el match (no toda la linea)
-E    Usar extended regex
-A N  Mostrar N lineas despues del match
-B N  Mostrar N lineas antes del match
-C N  Mostrar N lineas antes y despues del match
```

## Contribuir

Las contribuciones son bienvenidas! Para contribuir:

1. Fork este repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nuevo-template`)
3. Commit tus cambios (`git commit -m 'Add: nuevo template para X'`)
4. Push a la rama (`git push origin feature/nuevo-template`)
5. Abre un Pull Request

### Guidelines para nuevos templates

- Usa nombres descriptivos y en minusculas
- Agrupa templates por categoria logica
- Incluye comentarios en templates complejos
- Testea tus patrones antes de hacer PR
- Actualiza la documentacion

## Recursos Adicionales

- [GF Original por tomnomnom](https://github.com/tomnomnom/gf)
- [GF Patterns by 1ndianl33t](https://github.com/1ndianl33t/Gf-Patterns)
- [GF Patterns by CypherNova1337](https://github.com/CypherNova1337/GF_Patterns)
- [Bug Bounty Reference](https://github.com/ngalongc/bug-bounty-reference)
- [Nuclei Templates](https://github.com/projectdiscovery/nuclei-templates)

## Licencia

Este proyecto esta bajo la licencia MIT. Ver archivo [LICENSE](LICENSE) para mas detalles.

## Disclaimer

Estas herramientas son para propositos educativos y testing etico solamente. Siempre obten autorizacion antes de testear en sistemas que no sean tuyos. El uso indebido de estas herramientas puede ser ilegal.

## Creditos

- [tomnomnom](https://github.com/tomnomnom) - Creador de GF
- Comunidad de Bug Bounty por compartir patrones y tecnicas
- Todos los contribuidores de este repositorio

## Contacto

Si tienes preguntas o sugerencias, abre un issue en GitHub.

---

**Happy Hunting!** 🎯
