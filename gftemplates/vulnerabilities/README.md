# Vulnerabilities Templates

Templates para detectar vulnerabilidades web comunes y modernas.

## Categorias

### Injection (9 templates)

Vulnerabilidades de inyeccion donde input malicioso puede ejecutar comandos no deseados.

- **sqli.json**: SQL Injection - Detecta parametros susceptibles a inyeccion SQL
- **xss.json**: Cross-Site Scripting - Encuentra vectores de XSS reflejado y almacenado
- **ssrf.json**: Server-Side Request Forgery - Identifica parametros que pueden hacer requests del lado del servidor
- **lfi.json**: Local File Inclusion - Busca parametros que puedan leer archivos locales
- **rce.json**: Remote Code Execution - Detecta posibles vectores de ejecucion remota de codigo
- **xxe.json**: XML External Entity - Encuentra endpoints XML susceptibles a XXE
- **ssti.json**: Server-Side Template Injection - Identifica inyeccion en templates del servidor
- **nosqli.json**: NoSQL Injection - Detecta inyeccion en bases de datos NoSQL
- **csti.json**: Client-Side Template Injection - Encuentra inyeccion en templates del cliente

### Authentication & Authorization (6 templates)

Problemas relacionados con autenticacion y control de acceso.

- **jwt.json**: JWT Vulnerabilities - Detecta tokens JWT en requests y responses
- **oauth.json**: OAuth Issues - Encuentra endpoints OAuth y posibles problemas
- **idor.json**: Insecure Direct Object Reference - Identifica referencias directas a objetos
- **session.json**: Session Management - Detecta problemas de manejo de sesiones
- **broken-auth.json**: Broken Authentication - Encuentra endpoints de autenticacion
- **authz.json**: Authorization Issues - Identifica problemas de autorizacion

### Logic & Business (6 templates)

Fallas logicas y de negocio que no son de inyeccion.

- **cors.json**: CORS Misconfigurations - Detecta configuraciones CORS inseguras
- **redirect.json**: Open Redirects - Encuentra parametros de redireccion abierta
- **race-condition.json**: Race Conditions - Identifica endpoints susceptibles a condiciones de carrera
- **business-logic.json**: Business Logic Flaws - Detecta parametros de logica de negocio
- **rate-limit.json**: Rate Limiting Issues - Encuentra endpoints sin rate limiting
- **csrf.json**: Cross-Site Request Forgery - Detecta posibles vectores CSRF

### Modern Vulnerabilities (8 templates)

Vulnerabilidades modernas y emergentes.

- **prototype-pollution.json**: Prototype Pollution - Detecta contaminacion de prototipos en JavaScript
- **graphql.json**: GraphQL Security - Encuentra endpoints GraphQL y posibles problemas
- **websocket.json**: WebSocket Issues - Identifica conexiones WebSocket
- **api-abuse.json**: API Abuse - Detecta endpoints de API internos o no documentados
- **deserialization.json**: Insecure Deserialization - Encuentra deserializacion insegura
- **path-traversal.json**: Path Traversal - Detecta traversal de directorios
- **crlf-injection.json**: CRLF Injection - Identifica inyeccion CRLF
- **host-header.json**: Host Header Injection - Detecta inyeccion en header Host

## Uso

### Escaneo basico

```bash
# Buscar SQLi
cat urls.txt | gf sqli

# Buscar XSS
cat urls.txt | gf xss

# Buscar SSRF
cat urls.txt | gf ssrf
```

### Escaneo multiple

```bash
# Buscar todas las inyecciones
cat urls.txt | gf sqli | gf xss | gf lfi | gf rce

# Buscar problemas de autenticacion
cat urls.txt | gf jwt | gf oauth | gf idor
```

### Con validacion automatica

```bash
# SQLi con sqlmap
cat urls.txt | gf sqli | while read url; do
    sqlmap -u "$url" --batch --random-agent
done

# XSS con dalfox
cat urls.txt | gf xss | dalfox pipe

# SSRF con interactsh
cat urls.txt | gf ssrf | qsreplace "http://your-interactsh.com"
```

## Tips Especificos

### SQL Injection
- Busca parametros numericos y de busqueda
- Testea con `'` y observa errores
- Usa sqlmap para validacion automatica

### XSS
- Enfocate en parametros de input y search
- Testea reflected, stored y DOM-based
- Valida con burp o dalfox

### SSRF
- Busca parametros url, callback, webhook
- Usa interactsh para OOB detection
- Testea acceso a metadata de cloud

### LFI
- Busca parametros file, path, page
- Testea path traversal con ../
- Intenta acceder a /etc/passwd

## Flags Recomendados

```
-HnriE  Para la mayoria de vulnerabilidades
-HnrioE Para extraer solo el match
-A 3    Para ver contexto alrededor del match
```
