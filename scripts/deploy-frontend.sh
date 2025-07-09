#!/bin/bash

# 🚀 Script de despliegue automático del frontend
# Este script construye y despliega automáticamente los cambios del frontend

set -e

echo "🌟 Iniciando despliegue automático del frontend..."

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

# Cambiar al directorio del frontend
cd "$(dirname "$0")/../frontend"

print_color "📦 Instalando dependencias..." $BLUE
npm ci

print_color "🔨 Construyendo aplicación..." $BLUE
npm run build

print_color "📋 Verificando que existe el directorio out..." $BLUE
if [ ! -d "out" ]; then
    print_color "❌ Error: El directorio 'out' no existe después del build" $RED
    exit 1
fi

print_color "✅ Build completado exitosamente" $GREEN

# Verificar si SWA CLI está instalado
if ! command -v swa &> /dev/null; then
    print_color "⚠️  SWA CLI no está instalado. Instalando..." $YELLOW
    npm install -g @azure/static-web-apps-cli
fi

# Obtener el token de Azure Static Web Apps
print_color "🔑 Obteniendo token de Azure Static Web Apps..." $BLUE

# Intentar obtener el token automáticamente
SWA_TOKEN=$(az staticwebapp secrets list --name crudappstaticwebappdatafast --resource-group rg-crud-serverless-datafast --query "properties.apiKey" -o tsv 2>/dev/null || echo "")

if [ -z "$SWA_TOKEN" ]; then
    print_color "⚠️  No se pudo obtener el token automáticamente." $YELLOW
    print_color "📝 Por favor, ingresa tu token de Azure Static Web Apps:" $YELLOW
    print_color "   (Puedes obtenerlo con: az staticwebapp secrets list --name crudappstaticwebappdatafast --resource-group rg-crud-serverless-datafast --query \"properties.apiKey\" -o tsv)" $YELLOW
    read -r SWA_TOKEN
fi

if [ -z "$SWA_TOKEN" ]; then
    print_color "❌ Error: No se proporcionó un token válido" $RED
    exit 1
fi

print_color "🚀 Desplegando a Azure Static Web Apps..." $BLUE

# Desplegar usando SWA CLI
swa deploy ./out --deployment-token "$SWA_TOKEN"

if [ $? -eq 0 ]; then
    print_color "🎉 ¡Despliegue completado exitosamente!" $GREEN
    print_color "🔗 Tu aplicación se actualizará en unos minutos en:" $BLUE
    print_color "   https://crudappstaticwebappdatafast.azurestaticapps.net" $BLUE
else
    print_color "❌ Error durante el despliegue" $RED
    exit 1
fi

print_color "📋 Próximos pasos:" $BLUE
print_color "   1. Espera 2-3 minutos para que los cambios se reflejen" $YELLOW
print_color "   2. Verifica la aplicación en el navegador" $YELLOW
print_color "   3. Si hay problemas, revisa los logs en Azure Portal" $YELLOW
