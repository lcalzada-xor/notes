# Data & Encoding Templates

Templates para detectar diferentes formatos de datos y tipos de encoding.

## Categorias

### Serialization (3 templates)

Deteccion de formatos de serializacion de datos.

- **json-endpoints.json**: JSON Endpoints - Detecta endpoints y responses JSON
- **xml-endpoints.json**: XML Endpoints - Encuentra endpoints XML y SOAP
- **yaml-files.json**: YAML Files - Identifica archivos YAML

### Encoding (4 templates)

Deteccion de diferentes tipos de encoding.

- **base64.json**: Base64 Encoding - Detecta strings codificadas en base64
- **jwt-tokens.json**: JWT Tokens - Encuentra JSON Web Tokens
- **url-encoded.json**: URL Encoding - Identifica parametros URL-encoded
- **hex-encoded.json**: Hex Encoding - Detecta valores hexadecimales

## Uso

### Serialization

```bash
# Encontrar endpoints JSON
cat urls.txt | gf json-endpoints

# Encontrar endpoints XML (posible XXE)
cat urls.txt | gf xml-endpoints

# Encontrar archivos YAML
cat urls.txt | gf yaml-files
```

### Encoding

```bash
# Detectar base64
cat responses.txt | gf base64

# Extraer JWT tokens
cat traffic.txt | gf jwt-tokens

# Encontrar parametros encoded
cat urls.txt | gf url-encoded
```

## Use Cases

### 1. Analisis de JWT

```bash
# Extraer JWT tokens
cat responses.txt | gf jwt-tokens | tee jwts.txt

# Analizar JWTs
cat jwts.txt | while read jwt; do
    echo $jwt | cut -d. -f1,2 | base64 -d 2>/dev/null | jq
done
```

### 2. Decodificacion de Base64

```bash
# Encontrar y decodificar base64
cat responses.txt | gf base64 | while read b64; do
    echo $b64 | base64 -d 2>/dev/null
done
```

### 3. API Format Discovery

```bash
# Identificar formatos de API
cat urls.txt | gf json-endpoints | tee json_apis.txt
cat urls.txt | gf xml-endpoints | tee xml_apis.txt

# Testear cada formato
cat json_apis.txt | while read url; do
    curl -H "Content-Type: application/json" "$url"
done
```

## Tips

1. **JWT Analysis**: Siempre decodifica y analiza claims de JWT
2. **Base64**: No todo base64 es interesante, filtra resultados
3. **XML**: Endpoints XML son candidatos para XXE
4. **Format Discovery**: Saber el formato ayuda a seleccionar exploits
