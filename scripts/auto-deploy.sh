#!/bin/bash

# 🔄 Script de desarrollo con auto-despliegue
# Ejecuta este script después de hacer cambios para desplegar automáticamente

set -e

echo "🔄 Auto-Deploy Script - Gestión de Tareas CRUD"
echo "=============================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_color() {
    printf "${2}${1}${NC}\n"
}

# Verificar si estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio frontend/"
    echo "💡 Usa: cd frontend && ../scripts/auto-deploy.sh"
    exit 1
fi

print_color "📝 Iniciando proceso de auto-despliegue..." $BLUE

# 1. Build del proyecto
print_color "🔨 Construyendo aplicación..." $BLUE
npm run build

if [ $? -ne 0 ]; then
    print_color "❌ Error durante el build" $RED
    exit 1
fi

print_color "✅ Build completado" $GREEN

# 2. Verificar que SWA CLI está disponible
if ! command -v swa &> /dev/null; then
    print_color "📦 Instalando SWA CLI..." $YELLOW
    npm install -g @azure/static-web-apps-cli
fi

# 3. Obtener token automáticamente o pedirlo
print_color "🔑 Obteniendo token de despliegue..." $BLUE

# Intentar obtener el token desde Azure CLI
SWA_TOKEN=$(az staticwebapp secrets list --name crudappstaticwebappdatafast --resource-group rg-crud-serverless-datafast --query "properties.apiKey" -o tsv 2>/dev/null || echo "")

# Si no se pudo obtener automáticamente, pedirlo al usuario
if [ -z "$SWA_TOKEN" ] || [ "$SWA_TOKEN" = "null" ]; then
    print_color "⚠️  No se pudo obtener el token automáticamente" $YELLOW
    print_color "📝 Por favor, pega tu token de Azure Static Web Apps:" $YELLOW
    echo -n "Token: "
    read -r SWA_TOKEN
fi

if [ -z "$SWA_TOKEN" ]; then
    print_color "❌ Error: Se requiere un token válido" $RED
    exit 1
fi

# 4. Desplegar
print_color "🚀 Desplegando a Azure Static Web Apps..." $BLUE
swa deploy ./out --deployment-token "$SWA_TOKEN"

if [ $? -eq 0 ]; then
    print_color "🎉 ¡Despliegue completado exitosamente!" $GREEN
    print_color "🔗 URL: https://crudappstaticwebappdatafast.azurestaticapps.net" $BLUE
    print_color "⏱️  Los cambios aparecerán en 2-3 minutos" $YELLOW
    
    # Opción para abrir en navegador (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_color "🌐 ¿Abrir en navegador? (y/N)" $YELLOW
        read -r OPEN_BROWSER
        if [[ $OPEN_BROWSER =~ ^[Yy]$ ]]; then
            open "https://crudappstaticwebappdatafast.azurestaticapps.net"
        fi
    fi
else
    print_color "❌ Error durante el despliegue" $RED
    exit 1
fi

print_color "✨ Proceso completado!" $GREEN
