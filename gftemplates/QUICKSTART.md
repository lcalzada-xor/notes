# Quick Start Guide

Guia rapida para empezar a usar GF Templates en 5 minutos.

## Paso 1: Instalacion (2 minutos)

```bash
# Instalar Go (si no lo tienes)
# Visita: https://golang.org/dl/

# Instalar GF
go install github.com/tomnomnom/gf@latest

# Agregar Go bin al PATH
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# Clonar este repo
git clone https://github.com/yourusername/gf-templates.git
cd gf-templates

# Instalar templates
./INSTALL.sh
```

## Paso 2: Verificar Instalacion (30 segundos)

```bash
# Ver templates disponibles
gf -list

# Deberas ver una lista de ~70 templates
```

## Paso 3: Primer Uso (1 minuto)

```bash
# Crear un archivo de test
cat > test_urls.txt << 'EOF'
https://example.com/search?q=test
https://example.com/profile?id=123
https://example.com/api/users?token=abc123
https://example.com/redirect?url=https://evil.com
EOF

# Buscar posibles SQLi
cat test_urls.txt | gf sqli

# Buscar posibles XSS
cat test_urls.txt | gf xss

# Buscar posibles SSRF
cat test_urls.txt | gf ssrf
```

## Paso 4: Workflow Real (1 minuto)

```bash
# Ejemplo con un dominio real
domain="example.com"

# 1. Encontrar subdominios (necesitas subfinder)
# subfinder -d $domain -silent > subs.txt

# 2. URLs desde wayback
# cat subs.txt | waybackurls > urls.txt

# 3. Buscar vulnerabilidades
# cat urls.txt | gf sqli > sqli_targets.txt
# cat urls.txt | gf xss > xss_targets.txt
# cat urls.txt | gf ssrf > ssrf_targets.txt
```

## Templates Mas Usados

### Vulnerabilidades
```bash
gf sqli        # SQL Injection
gf xss         # Cross-Site Scripting
gf ssrf        # Server-Side Request Forgery
gf lfi         # Local File Inclusion
gf rce         # Remote Code Execution
gf idor        # Insecure Direct Object Reference
```

### Secretos
```bash
gf aws-keys          # AWS Keys
gf github-tokens     # GitHub Tokens
gf api-keys          # Generic API Keys
gf credentials       # Usernames & Passwords
```

### Reconocimiento
```bash
gf api-endpoints     # API Endpoints
gf admin-panels      # Admin Panels
gf interesting-params # Parametros Interesantes
gf javascript-files  # JavaScript Files
```

## Tips Rapidos

1. **Combina con otras herramientas:**
   ```bash
   cat urls.txt | gf xss | dalfox pipe
   ```

2. **Usa qsreplace para fuzzing:**
   ```bash
   cat urls.txt | gf sqli | qsreplace "'"
   ```

3. **Filtra resultados:**
   ```bash
   cat urls.txt | gf sqli | httpx -mc 200
   ```

4. **Guarda resultados:**
   ```bash
   cat urls.txt | gf sqli | tee sqli.txt
   ```

## Proximos Pasos

- Lee el [README.md](README.md) completo
- Consulta el [CHEATSHEET.md](CHEATSHEET.md) para mas ejemplos
- Mira los [workflows completos](README.md#workflows-recomendados)

## Ayuda

Si tienes problemas:

1. Verifica que GF este instalado: `gf -list`
2. Verifica que los templates esten en `~/.gf/`
3. Lee la documentacion completa
4. Abre un issue en GitHub

Happy Hunting! 🎯
