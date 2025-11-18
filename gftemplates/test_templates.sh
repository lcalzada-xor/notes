#!/bin/bash

# GF Templates Testing Script
# Valida que todos los templates esten correctamente formados

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "================================================"
echo "  GF Templates Validation Script"
echo "================================================"
echo -e "${NC}"

ERRORS=0
WARNINGS=0
SUCCESS=0

# Verificar si jq esta instalado
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}[!] jq no esta instalado. Instalando...${NC}"
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y jq
    elif command -v brew &> /dev/null; then
        brew install jq
    else
        echo -e "${RED}[!] No se pudo instalar jq automaticamente. Instalalo manualmente.${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}[*] Buscando templates JSON...${NC}"
echo ""

# Encontrar todos los archivos JSON
TEMPLATES=$(find . -name "*.json" -type f | grep -v node_modules | grep -v .git)
TOTAL=$(echo "$TEMPLATES" | wc -l)

echo -e "${BLUE}[*] Encontrados $TOTAL templates${NC}"
echo ""

# Validar cada template
for template in $TEMPLATES; do
    template_name=$(basename "$template")

    # Test 1: Validar JSON syntax
    if jq empty "$template" 2>/dev/null; then
        echo -e "${GREEN}[✓]${NC} $template - JSON valido"

        # Test 2: Verificar campos requeridos
        has_flags=$(jq 'has("flags")' "$template")
        has_pattern=$(jq 'has("pattern") or has("patterns")' "$template")

        if [[ "$has_flags" == "true" ]]; then
            echo -e "    ${GREEN}✓${NC} Tiene campo 'flags'"
        else
            echo -e "    ${RED}✗${NC} Falta campo 'flags'"
            ((ERRORS++))
        fi

        if [[ "$has_pattern" == "true" ]]; then
            echo -e "    ${GREEN}✓${NC} Tiene campo 'pattern' o 'patterns'"

            # Test 3: Validar que patterns no este vacio
            patterns_count=$(jq '[.patterns // .pattern] | flatten | length' "$template")
            if [[ $patterns_count -gt 0 ]]; then
                echo -e "    ${GREEN}✓${NC} Contiene $patterns_count patron(es)"
            else
                echo -e "    ${RED}✗${NC} No contiene patrones"
                ((ERRORS++))
            fi
        else
            echo -e "    ${RED}✗${NC} Falta campo 'pattern' o 'patterns'"
            ((ERRORS++))
        fi

        # Test 4: Verificar flags comunes
        flags=$(jq -r '.flags' "$template")
        if [[ "$flags" == *"-E"* ]]; then
            echo -e "    ${GREEN}✓${NC} Usa extended regex (-E)"
        else
            echo -e "    ${YELLOW}⚠${NC} No usa extended regex (-E)"
            ((WARNINGS++))
        fi

        if [[ "$flags" == *"-H"* ]]; then
            echo -e "    ${GREEN}✓${NC} Muestra filename (-H)"
        else
            echo -e "    ${YELLOW}⚠${NC} No muestra filename (-H)"
            ((WARNINGS++))
        fi

        if [[ "$flags" == *"-n"* ]]; then
            echo -e "    ${GREEN}✓${NC} Muestra line numbers (-n)"
        else
            echo -e "    ${YELLOW}⚠${NC} No muestra line numbers (-n)"
            ((WARNINGS++))
        fi

        ((SUCCESS++))
    else
        echo -e "${RED}[✗]${NC} $template - JSON invalido"
        echo -e "    ${RED}Error:${NC} $(jq empty "$template" 2>&1)"
        ((ERRORS++))
    fi

    echo ""
done

# Resumen
echo ""
echo -e "${BLUE}================================================"
echo "  Resumen de Validacion"
echo "================================================${NC}"
echo ""
echo -e "Total de templates:  ${BLUE}$TOTAL${NC}"
echo -e "Exitosos:           ${GREEN}$SUCCESS${NC}"
echo -e "Errores:            ${RED}$ERRORS${NC}"
echo -e "Advertencias:       ${YELLOW}$WARNINGS${NC}"
echo ""

# Test de estructura de directorios
echo -e "${BLUE}[*] Validando estructura de directorios...${NC}"
echo ""

REQUIRED_DIRS=(
    "vulnerabilities/injection"
    "vulnerabilities/auth"
    "vulnerabilities/logic"
    "vulnerabilities/modern"
    "secrets/cloud"
    "secrets/saas"
    "secrets/generic"
    "recon/parameters"
    "recon/endpoints"
    "recon/technologies"
    "data/serialization"
    "data/encoding"
    "custom"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -maxdepth 1 -name "*.json" -type f | wc -l)
        echo -e "${GREEN}[✓]${NC} $dir ($count templates)"
    else
        echo -e "${RED}[✗]${NC} $dir - No existe"
        ((ERRORS++))
    fi
done

echo ""

# Test de documentacion
echo -e "${BLUE}[*] Validando documentacion...${NC}"
echo ""

REQUIRED_DOCS=(
    "README.md"
    "CHEATSHEET.md"
    "CONTRIBUTING.md"
    "INSTALL.sh"
    "vulnerabilities/README.md"
    "secrets/README.md"
    "recon/README.md"
    "data/README.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        size=$(wc -c < "$doc")
        if [ $size -gt 100 ]; then
            echo -e "${GREEN}[✓]${NC} $doc (${size} bytes)"
        else
            echo -e "${YELLOW}[⚠]${NC} $doc (${size} bytes - parece muy corto)"
            ((WARNINGS++))
        fi
    else
        echo -e "${RED}[✗]${NC} $doc - No existe"
        ((ERRORS++))
    fi
done

echo ""

# Resultado final
echo -e "${BLUE}================================================${NC}"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}[✓] Todos los tests pasaron!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}[!] Hay $WARNINGS advertencias que deberian revisarse${NC}"
    fi
    echo -e "${BLUE}================================================${NC}"
    exit 0
else
    echo -e "${RED}[✗] Tests fallaron con $ERRORS error(es)${NC}"
    echo -e "${BLUE}================================================${NC}"
    exit 1
fi
