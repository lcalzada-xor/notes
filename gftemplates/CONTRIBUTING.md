# Contributing to GF Templates

Gracias por tu interes en contribuir! Este documento proporciona guias para contribuir a este repositorio.

## Como Contribuir

### Reportar Bugs o Sugerir Mejoras

1. Abre un [Issue](https://github.com/yourusername/gf-templates/issues)
2. Describe claramente el problema o la sugerencia
3. Incluye ejemplos si es posible

### Agregar Nuevos Templates

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nuevo-template`)
3. Agrega tu template en la categoria apropiada
4. Sigue las convenciones de este documento
5. Testea tu template
6. Commit tus cambios (`git commit -m 'Add: template para X'`)
7. Push a la rama (`git push origin feature/nuevo-template`)
8. Abre un Pull Request

## Estructura de Templates

### Formato JSON

Todos los templates deben ser archivos JSON validos:

```json
{
  "flags": "-HnriE",
  "patterns": [
    "pattern1",
    "pattern2"
  ]
}
```

### Campos

- **flags**: Flags de grep a usar (string)
- **pattern**: Un solo patron (string) - usar cuando hay solo un patron
- **patterns**: Array de patrones (array) - usar cuando hay multiples patrones

### Flags Recomendados

| Flag | Uso | Cuando usarlo |
|------|-----|---------------|
| `-H` | Mostrar nombre de archivo | Siempre |
| `-n` | Mostrar numero de linea | Siempre |
| `-r` | Busqueda recursiva | Siempre |
| `-i` | Case insensitive | Vulnerabilidades |
| `-o` | Solo mostrar match | Secretos |
| `-E` | Extended regex | Siempre |

**Combinaciones comunes:**
- Vulnerabilidades: `-HnriE`
- Secretos: `-HnrioE`
- Recon: `-HnrioE`

## Convenciones de Nomenclatura

### Nombres de Archivos

- Usa minusculas
- Usa guiones para separar palabras (`multi-word.json`)
- Usa nombres descriptivos
- Extension `.json` siempre

**Ejemplos:**
- ✅ `sqli.json`
- ✅ `aws-keys.json`
- ✅ `api-endpoints.json`
- ❌ `SQLi.json`
- ❌ `aws_keys.json`
- ❌ `api.json` (muy generico)

### Organizacion de Directorios

Coloca tu template en la categoria correcta:

```
vulnerabilities/
  injection/      # SQLi, XSS, RCE, etc.
  auth/           # JWT, OAuth, IDOR, etc.
  logic/          # CORS, Redirect, CSRF, etc.
  modern/         # GraphQL, WebSocket, etc.

secrets/
  cloud/          # AWS, GCP, Azure, etc.
  saas/           # GitHub, Slack, Stripe, etc.
  generic/        # API keys, tokens, etc.

recon/
  parameters/     # Parametros interesantes
  endpoints/      # APIs, admin panels, etc.
  technologies/   # Frameworks, CMS, etc.

data/
  serialization/  # JSON, XML, YAML
  encoding/       # Base64, JWT, etc.
```

## Escribiendo Buenos Patrones

### Principios Generales

1. **Especificidad**: Los patrones deben ser lo suficientemente especificos para evitar false positives
2. **Cobertura**: Pero no tan especificos que pierdan casos validos
3. **Performance**: Evita regex excesivamente complejos
4. **Claridad**: Patrones deben ser entendibles

### Ejemplos de Buenos Patrones

#### SQL Injection
```json
{
  "flags": "-HnriE",
  "patterns": [
    "[?&](id|user|account|page|product)=",
    "[?&]([a-zA-Z0-9_-]+)=.*?('|%27|--|#)",
    "\\.(php|asp)\\?[^\\s]*?\\b(and|or|union|select)\\b"
  ]
}
```

**Por que es bueno:**
- Busca parametros comunes
- Detecta caracteres maliciosos
- Encuentra extensiones y palabras clave SQL

#### AWS Keys
```json
{
  "flags": "-HnrioE",
  "patterns": [
    "AKIA[0-9A-Z]{16}",
    "aws_access_key_id\\s*[:=]\\s*['\"]?AKIA[0-9A-Z]{16}",
    "aws_secret_access_key\\s*[:=]\\s*['\"]?[A-Za-z0-9/+=]{40}"
  ]
}
```

**Por que es bueno:**
- Formato especifico de AWS (bajo false positive rate)
- Busca tanto el key como el contexto
- Cubre diferentes formatos de declaracion

### Patrones a Evitar

❌ **Demasiado generico:**
```json
{
  "patterns": [
    "admin",
    "password",
    "key"
  ]
}
```

❌ **Demasiado complejo:**
```json
{
  "patterns": [
    "(?:(?:(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9])|(?:\\[(?:(?:(?:[0-9a-f]{1,4}:){7}(?:[0-9a-f]{1,4}|:))|(?:(?:[0-9a-f]{1,4}:){6}(?::[0-9a-f]{1,4}|(?:(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(?:\\.(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:)))\\]))"
  ]
}
```

✅ **Balance correcto:**
```json
{
  "patterns": [
    "/admin",
    "/administrator",
    "/wp-admin",
    "/dashboard",
    "[?&](admin|administrator)="
  ]
}
```

## Testing de Templates

### Testing Manual

Antes de hacer PR, testea tu template:

```bash
# Test basico
echo "test_string_here" | gf your-template

# Test con archivo real
cat real_data.txt | gf your-template

# Test con multiples casos
cat test_cases.txt | gf your-template
```

### Casos de Test

Crea un archivo de test con:
- Casos positivos (debe detectar)
- Casos negativos (no debe detectar)
- Edge cases

Ejemplo para SQLi:
```
# Positivos
http://example.com?id=1
http://example.com?user=admin
http://example.com?id=1' OR '1'='1

# Negativos
http://example.com
http://example.com/about
http://example.com/static/image.jpg

# Edge cases
http://example.com?id=
http://example.com?id[]=1
```

### Criterios de Calidad

Tu template debe:
- [ ] Detectar al menos 80% de casos positivos
- [ ] Tener menos de 20% de false positives
- [ ] Funcionar en diferentes contextos
- [ ] Ser performante (< 1 segundo para 1000 lineas)

## Documentacion

### README

Si creas una nueva categoria, incluye un README.md con:

1. Descripcion de la categoria
2. Lista de templates
3. Ejemplos de uso
4. Tips especificos

### Comentarios en Codigo

Para templates complejos, agrega comentarios:

```json
{
  "flags": "-HnriE",
  "patterns": [
    "pattern1",  // Explicacion del patron
    "pattern2"   // Explicacion del patron
  ]
}
```

### Actualizacion de Documentacion

Si agregas templates nuevos, actualiza:
- README.md principal
- README.md de categoria
- CHEATSHEET.md si aplica

## Estilo de Commits

Usa mensajes de commit descriptivos:

```
Add: nuevo template para X
Update: mejora template Y
Fix: corrige false positives en Z
Docs: actualiza documentacion de W
```

### Prefijos

- `Add:` - Nuevo template o feature
- `Update:` - Mejora a template existente
- `Fix:` - Correccion de bug
- `Docs:` - Cambios en documentacion
- `Test:` - Agregar o actualizar tests
- `Refactor:` - Reorganizacion de codigo

## Proceso de Review

Tu PR sera revisado considerando:

1. **Funcionalidad**: El template funciona correctamente?
2. **Calidad**: Sigue las convenciones y best practices?
3. **Documentacion**: Esta bien documentado?
4. **Testing**: Fue testeado adecuadamente?
5. **Originalidad**: Agrega valor real al proyecto?

## Templates de PR

### Para Nuevo Template

```markdown
## Descripcion
Breve descripcion del template y que detecta.

## Categoria
- [ ] Vulnerabilities
- [ ] Secrets
- [ ] Recon
- [ ] Data

## Checklist
- [ ] Template testeado con casos reales
- [ ] Documentacion actualizada
- [ ] Sigue convenciones de nomenclatura
- [ ] False positive rate < 20%
- [ ] Incluye ejemplos de uso

## Ejemplos
Incluye ejemplos de que detecta el template.
```

### Para Mejora a Template Existente

```markdown
## Template Mejorado
Nombre del template mejorado.

## Cambios
- Lista de cambios realizados
- Que mejora
- Por que

## Testing
Resultados de testing antes y despues.

## Impacto
Como afecta a usuarios existentes (breaking changes?).
```

## Recursos para Contribuidores

### Herramientas Utiles

- [regex101.com](https://regex101.com) - Testear regex online
- [GF Original](https://github.com/tomnomnom/gf) - Documentacion oficial
- [RegExr](https://regexr.com) - Otra herramienta de regex

### Referencias

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Bug Bounty Reference](https://github.com/ngalongc/bug-bounty-reference)
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)

## Codigo de Conducta

- Se respetuoso con otros contribuidores
- Acepta criticas constructivas
- Enfocate en lo mejor para el proyecto
- Ayuda a otros cuando puedas

## Preguntas?

Si tienes preguntas sobre como contribuir:

1. Revisa la documentacion existente
2. Busca en Issues cerrados
3. Abre un nuevo Issue con tu pregunta

## Licencia

Al contribuir, aceptas que tus contribuciones seran licenciadas bajo la misma licencia que el proyecto (MIT).

---

Gracias por contribuir y hacer este proyecto mejor! 🎯
