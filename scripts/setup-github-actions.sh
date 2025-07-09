#!/bin/bash

# 🚀 Script de configuración inicial para GitHub Actions
# Este script ayuda a configurar los secrets y variables necesarios

set -e

echo "🚀 Configurando GitHub Actions para el proyecto CRUD App..."

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

print_color "🔍 Verificando requisitos..." $BLUE

# Verificar si Azure CLI está instalado
if ! command -v az &> /dev/null; then
    print_color "❌ Azure CLI no está instalado. Instálalo desde: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" $RED
    exit 1
fi

# Verificar si GitHub CLI está instalado
if ! command -v gh &> /dev/null; then
    print_color "⚠️  GitHub CLI no está instalado. Instálalo desde: https://cli.github.com/" $YELLOW
    print_color "   Puedes configurar los secrets manualmente en GitHub web interface" $YELLOW
fi

print_color "✅ Requisitos verificados" $GREEN

# Login a Azure
print_color "🔑 Iniciando sesión en Azure..." $BLUE
az login

# Obtener subscription ID
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
print_color "📋 Subscription ID: $SUBSCRIPTION_ID" $BLUE

# Crear service principal
print_color "👤 Creando service principal para GitHub Actions..." $BLUE
AZURE_CREDS=$(az ad sp create-for-rbac \
    --name "github-actions-crud-app-$(date +%s)" \
    --role contributor \
    --scopes "/subscriptions/$SUBSCRIPTION_ID" \
    --sdk-auth)

print_color "✅ Service principal creado" $GREEN

# Mostrar credenciales (para configuración manual si GitHub CLI no está disponible)
print_color "📝 Credenciales de Azure (para AZURE_CREDENTIALS secret):" $YELLOW
echo "$AZURE_CREDS"
echo ""

# Configurar GitHub secrets si GitHub CLI está disponible
if command -v gh &> /dev/null; then
    print_color "🔧 Configurando GitHub secrets..." $BLUE
    
    # Verificar autenticación en GitHub
    if ! gh auth status &> /dev/null; then
        print_color "🔑 Autenticándose en GitHub..." $BLUE
        gh auth login
    fi
    
    # Configurar AZURE_CREDENTIALS
    echo "$AZURE_CREDS" | gh secret set AZURE_CREDENTIALS
    print_color "✅ AZURE_CREDENTIALS configurado" $GREEN
    
    # Solicitar SQL Connection String
    print_color "📝 Ingresa la cadena de conexión de SQL Server:" $YELLOW
    print_color "   Formato: Server=tcp:{server}.database.windows.net,1433;Initial Catalog={db};User ID={user};Password={pass};Encrypt=True;" $YELLOW
    read -r SQL_CONN_STRING
    echo "$SQL_CONN_STRING" | gh secret set SQL_CONNECTION_STRING
    print_color "✅ SQL_CONNECTION_STRING configurado" $GREEN
    
    # Solicitar Static Web Apps token
    print_color "📝 Ingresa el token de Azure Static Web Apps:" $YELLOW
    print_color "   (Obtener desde Azure Portal > Static Web Apps > Manage deployment token)" $YELLOW
    read -r SWA_TOKEN
    echo "$SWA_TOKEN" | gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN
    print_color "✅ AZURE_STATIC_WEB_APPS_API_TOKEN configurado" $GREEN
    
    # Preguntar por Infracost (opcional)
    print_color "📝 ¿Deseas configurar Infracost para estimación de costos? (y/N)" $YELLOW
    read -r USE_INFRACOST
    if [[ $USE_INFRACOST =~ ^[Yy]$ ]]; then
        print_color "📝 Ingresa tu Infracost API Key:" $YELLOW
        read -r INFRACOST_KEY
        echo "$INFRACOST_KEY" | gh secret set INFRACOST_API_KEY
        print_color "✅ INFRACOST_API_KEY configurado" $GREEN
    fi
    
    print_color "🎉 Todos los secrets han sido configurados exitosamente!" $GREEN
else
    print_color "⚠️  GitHub CLI no está disponible. Configura los siguientes secrets manualmente:" $YELLOW
    print_color "   1. Ve a Settings > Secrets and variables > Actions en tu repositorio" $YELLOW
    print_color "   2. Añade estos secrets:" $YELLOW
    print_color "      - AZURE_CREDENTIALS: (las credenciales mostradas arriba)" $YELLOW
    print_color "      - SQL_CONNECTION_STRING: Tu cadena de conexión de SQL Server" $YELLOW
    print_color "      - AZURE_STATIC_WEB_APPS_API_TOKEN: Token de Static Web Apps" $YELLOW
    print_color "      - INFRACOST_API_KEY: (opcional) Tu API key de Infracost" $YELLOW
fi

print_color "📚 Próximos pasos:" $BLUE
print_color "   1. Configura el environment 'production' en GitHub" $YELLOW
print_color "   2. Añade reviewers requeridos para despliegues" $YELLOW
print_color "   3. Haz push de los cambios para activar el primer workflow" $YELLOW
print_color "   4. Revisa la documentación en .github/workflows/secrets-template.md" $YELLOW

print_color "✅ Configuración inicial completada!" $GREEN
