#!/bin/bash

# GF Templates Installation Script
# Este script instala GF y todos los templates de este repositorio

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}"
echo "================================================"
echo "  GF Templates Installation Script"
echo "================================================"
echo -e "${NC}"

# Verificar si go esta instalado
if ! command -v go &> /dev/null; then
    echo -e "${RED}[!] Go no esta instalado. Por favor instala Go primero.${NC}"
    echo "Visit: https://golang.org/dl/"
    exit 1
fi

# Verificar si gf esta instalado
if ! command -v gf &> /dev/null; then
    echo -e "${YELLOW}[+] GF no encontrado. Instalando GF...${NC}"
    go install github.com/tomnomnom/gf@latest

    # Agregar GOPATH al PATH si no esta
    if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
        echo -e "${YELLOW}[+] Agregando GOPATH al PATH...${NC}"
        echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
        export PATH=$PATH:$HOME/go/bin
    fi

    echo -e "${GREEN}[✓] GF instalado exitosamente${NC}"
else
    echo -e "${GREEN}[✓] GF ya esta instalado${NC}"
fi

# Crear directorio de configuracion de GF
GF_DIR="$HOME/.gf"
if [ ! -d "$GF_DIR" ]; then
    echo -e "${YELLOW}[+] Creando directorio ~/.gf...${NC}"
    mkdir -p "$GF_DIR"
fi

# Copiar todos los templates
echo -e "${YELLOW}[+] Instalando templates...${NC}"

# Backup de templates existentes
if [ "$(ls -A $GF_DIR)" ]; then
    BACKUP_DIR="$HOME/.gf_backup_$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}[+] Haciendo backup de templates existentes en $BACKUP_DIR${NC}"
    cp -r "$GF_DIR" "$BACKUP_DIR"
fi

# Copiar templates organizados
echo -e "${YELLOW}[+] Copiando templates de vulnerabilidades...${NC}"
cp -r vulnerabilities "$GF_DIR/"

echo -e "${YELLOW}[+] Copiando templates de secretos...${NC}"
cp -r secrets "$GF_DIR/"

echo -e "${YELLOW}[+] Copiando templates de reconocimiento...${NC}"
cp -r recon "$GF_DIR/"

echo -e "${YELLOW}[+] Copiando templates de datos...${NC}"
cp -r data "$GF_DIR/"

echo -e "${YELLOW}[+] Copiando templates custom...${NC}"
cp -r custom "$GF_DIR/"

# Contar templates instalados
total_templates=$(find "$GF_DIR" -name "*.json" | wc -l)

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}[✓] Instalacion completada!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${GREEN}Templates instalados: $total_templates${NC}"
echo ""
echo "Uso basico:"
echo "  gf -list                 # Listar todos los templates"
echo "  cat urls.txt | gf sqli   # Buscar SQLi"
echo "  cat file.txt | gf aws-keys  # Buscar AWS keys"
echo ""
echo "Para mas informacion, lee el README.md"
echo ""

# Verificar instalacion
echo -e "${YELLOW}[+] Verificando instalacion...${NC}"
if gf -list &> /dev/null; then
    echo -e "${GREEN}[✓] Verificacion exitosa!${NC}"
    echo ""
    echo "Templates disponibles:"
    gf -list | head -20
    if [ $(gf -list | wc -l) -gt 20 ]; then
        echo "... y $(( $(gf -list | wc -l) - 20 )) mas"
    fi
else
    echo -e "${RED}[!] Hubo un problema con la instalacion${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Happy Hunting! 🎯${NC}"
