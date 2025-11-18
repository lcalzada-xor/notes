# Reconnaissance Templates

Templates para reconocimiento y descubrimiento de assets, endpoints y tecnologias.

## Categorias

### Parameters (4 templates)

Deteccion de parametros interesantes en URLs.

- **interesting-params.json**: Parametros Interesantes - debug, admin, config, test, etc.
- **sensitive-params.json**: Parametros Sensibles - email, phone, ssn, credit card, etc.
- **upload-params.json**: Parametros de Upload - file, upload, image, document, etc.
- **filter-params.json**: Parametros de Filtrado - filter, search, sort, limit, etc.

### Endpoints (5 templates)

Descubrimiento de endpoints y rutas importantes.

- **api-endpoints.json**: API Endpoints - REST APIs, GraphQL, Swagger, etc.
- **admin-panels.json**: Admin Panels - /admin, /dashboard, /console, etc.
- **debug-endpoints.json**: Debug Endpoints - /debug, /test, /dev, /phpinfo, etc.
- **backup-files.json**: Backup Files - .bak, .old, .zip, .sql, .git, etc.
- **config-files.json**: Config Files - .config, .cfg, .ini, web.config, etc.

### Technologies (4 templates)

Identificacion de tecnologias y frameworks.

- **frameworks.json**: Frameworks - WordPress, Laravel, React, etc.
- **javascript-files.json**: JavaScript Files - .js, bundle.js, vendor.js, etc.
- **cms-detection.json**: CMS Detection - WordPress, Drupal, Joomla, etc.
- **cdn-detection.json**: CDN Detection - Cloudflare, Akamai, AWS CloudFront, etc.

## Uso

### Descubrimiento de parametros

```bash
# Encontrar parametros interesantes
cat urls.txt | gf interesting-params

# Encontrar parametros sensibles
cat urls.txt | gf sensitive-params

# Encontrar parametros de upload
cat urls.txt | gf upload-params
```

### Descubrimiento de endpoints

```bash
# Encontrar APIs
cat wayback.txt | gf api-endpoints

# Encontrar paneles admin
cat urls.txt | gf admin-panels | httpx -mc 200

# Encontrar archivos de backup
cat urls.txt | gf backup-files
```

### Fingerprinting de tecnologias

```bash
# Detectar frameworks
cat responses.txt | gf frameworks

# Encontrar archivos JS
cat urls.txt | gf javascript-files

# Detectar CMS
cat urls.txt | gf cms-detection
```

## Workflows de Reconocimiento

### 1. Recon Completo de Subdominios

```bash
#!/bin/bash
domain=$1

# Subdomain enumeration
subfinder -d $domain -silent | tee subs.txt
amass enum -passive -d $domain | tee -a subs.txt
cat subs.txt | sort -u | httpx -silent | tee live_subs.txt

# URL discovery
cat live_subs.txt | waybackurls | tee urls.txt
cat live_subs.txt | katana -silent | tee -a urls.txt

# Parameter discovery
cat urls.txt | gf interesting-params | tee interesting_params.txt
cat urls.txt | gf sensitive-params | tee sensitive_params.txt

# Endpoint discovery
cat urls.txt | gf api-endpoints | tee apis.txt
cat urls.txt | gf admin-panels | tee admin.txt
cat urls.txt | gf backup-files | tee backups.txt
```

### 2. JavaScript Recon

```bash
# Extraer y analizar todos los JS files
cat urls.txt | gf javascript-files | tee js_files.txt

# Descargar JS files
cat js_files.txt | while read js_url; do
    curl -s "$js_url" -o "js/$(echo $js_url | md5sum | cut -d' ' -f1).js"
done

# Buscar endpoints en JS
find js/ -type f | while read file; do
    cat "$file" | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | tee -a endpoints_from_js.txt
done

# Buscar API keys en JS
find js/ -type f | while read file; do
    cat "$file" | gf api-keys | tee -a keys_from_js.txt
done
```

### 3. API Discovery

```bash
# Encontrar APIs
cat urls.txt | gf api-endpoints | tee apis.txt

# Probar diferentes metodos HTTP
cat apis.txt | while read api; do
    for method in GET POST PUT DELETE PATCH; do
        echo "$method $api"
        curl -X $method -s -o /dev/null -w "%{http_code}" "$api"
    done
done

# Buscar documentacion de API
cat apis.txt | sed 's|/v[0-9].*|/swagger.json|' | httpx -mc 200
cat apis.txt | sed 's|/v[0-9].*|/api-docs|' | httpx -mc 200
```

### 4. Admin Panel Discovery

```bash
# Buscar paneles admin
cat urls.txt | gf admin-panels | httpx -mc 200,401,403 | tee admin_found.txt

# Fuerza bruta en admin panels encontrados
cat admin_found.txt | while read admin_url; do
    base_url=$(echo $admin_url | sed 's|/admin.*||')
    ffuf -u "$base_url/FUZZ" -w admin_paths.txt -mc 200,401,403
done
```

### 5. Config & Backup Files

```bash
# Buscar archivos de configuracion
cat urls.txt | gf config-files | httpx -mc 200 | tee configs.txt

# Buscar backups
cat urls.txt | gf backup-files | httpx -mc 200 | tee backups.txt

# Generar variaciones de backup
cat urls.txt | while read url; do
    echo "$url.bak"
    echo "$url.old"
    echo "$url~"
    echo "${url}.zip"
done | httpx -mc 200
```

## Tips de Reconocimiento

### Parameters

1. **Busca en multiples fuentes**: Wayback, CommonCrawl, AlienVault, URLScan
2. **Analiza patrones**: Si ves `?id=1`, busca otros parametros similares
3. **Prueba variaciones**: user, userid, user_id, userId son todos diferentes
4. **Combina con fuzzing**: Usa parametros encontrados como base para fuzzing

### Endpoints

1. **No ignores status codes**: 401/403 pueden indicar recursos protegidos
2. **Prueba path traversal**: ../admin podria existir aunque /admin no
3. **Busca versionado**: /api/v1, /api/v2, etc.
4. **Documenta todo**: Mantén registro de todos los endpoints encontrados

### Technologies

1. **Fingerprinting ayuda a enfocar**: Saber el tech stack ayuda a buscar vulns especificas
2. **Busca versiones**: Versiones antiguas pueden tener vulns conocidas
3. **CDN bypass**: Si hay CDN, busca el origen real
4. **JavaScript es oro**: Los archivos JS revelan mucha informacion

## Integracion con Otras Tools

### Con HTTPx

```bash
cat urls.txt | gf api-endpoints | httpx -silent -mc 200 -json | jq
```

### Con Nuclei

```bash
cat urls.txt | gf admin-panels | nuclei -t ~/nuclei-templates/exposures/
```

### Con FFUF

```bash
cat urls.txt | gf interesting-params | while read url; do
    ffuf -u "$url" -w params.txt -mc 200
done
```

### Con Arjun

```bash
cat urls.txt | gf api-endpoints | while read url; do
    arjun -u "$url"
done
```

## Output y Organizacion

Organiza tus resultados de recon:

```
target.com/
├── recon/
│   ├── subdomains.txt
│   ├── urls.txt
│   ├── parameters/
│   │   ├── interesting.txt
│   │   ├── sensitive.txt
│   │   └── upload.txt
│   ├── endpoints/
│   │   ├── apis.txt
│   │   ├── admin.txt
│   │   └── backups.txt
│   └── technologies/
│       ├── frameworks.txt
│       ├── cms.txt
│       └── js_files.txt
└── vulnerabilities/
    ├── sqli.txt
    ├── xss.txt
    └── secrets.txt
```

## Automatizacion

Script completo de recon automatizado:

```bash
#!/bin/bash
# auto_recon.sh

domain=$1
output_dir="recon_$domain"
mkdir -p $output_dir/{parameters,endpoints,technologies}

echo "[+] Starting reconnaissance for $domain"

# Subdomains
echo "[+] Enumerating subdomains..."
subfinder -d $domain -silent > $output_dir/subdomains.txt
cat $output_dir/subdomains.txt | httpx -silent > $output_dir/live_subs.txt

# URLs
echo "[+] Discovering URLs..."
cat $output_dir/live_subs.txt | waybackurls | tee $output_dir/urls.txt
cat $output_dir/live_subs.txt | katana -silent | tee -a $output_dir/urls.txt

# Parameters
echo "[+] Analyzing parameters..."
cat $output_dir/urls.txt | gf interesting-params > $output_dir/parameters/interesting.txt
cat $output_dir/urls.txt | gf sensitive-params > $output_dir/parameters/sensitive.txt
cat $output_dir/urls.txt | gf upload-params > $output_dir/parameters/upload.txt

# Endpoints
echo "[+] Discovering endpoints..."
cat $output_dir/urls.txt | gf api-endpoints > $output_dir/endpoints/apis.txt
cat $output_dir/urls.txt | gf admin-panels > $output_dir/endpoints/admin.txt
cat $output_dir/urls.txt | gf backup-files > $output_dir/endpoints/backups.txt

# Technologies
echo "[+] Identifying technologies..."
cat $output_dir/urls.txt | gf frameworks > $output_dir/technologies/frameworks.txt
cat $output_dir/urls.txt | gf javascript-files > $output_dir/technologies/js_files.txt
cat $output_dir/urls.txt | gf cms-detection > $output_dir/technologies/cms.txt

echo "[+] Reconnaissance completed! Results in $output_dir/"
```
