#!/bin/bash

# Script de despliegue automatizado para Linux/macOS
# Usar después de terraform apply

# Configurar variables
FUNCTION_APP_NAME="crudappfunctiondatafast"
STATIC_WEB_APP_NAME="crudappstaticwebappdatafast"
RESOURCE_GROUP_NAME="rg-crud-serverless-datafast"

echo "🚀 Iniciando despliegue de la aplicación CRUD de tareas..."

# 1. Deploy del backend (Azure Functions)
echo "📦 Desplegando Backend (.NET Core 8)..."
cd backend
dotnet publish --configuration Release --output ./publish
cd publish
zip -r ../function-app.zip .
cd ..
az functionapp deployment source config-zip --resource-group $RESOURCE_GROUP_NAME --name $FUNCTION_APP_NAME --src ./function-app.zip
rm ./function-app.zip
rm -rf ./publish

# 2. Deploy del frontend (Next.js)
echo "🌐 Desplegando Frontend (Next.js)..."
cd ../frontend
npm install
npm run build

# 3. Configurar Static Web App
az staticwebapp environment set --name $STATIC_WEB_APP_NAME --environment-name default --api-location "backend" --app-location "frontend/out"

echo "✅ Despliegue completado!"
echo "🔗 URLs de la aplicación:"
echo "   Backend API: https://$FUNCTION_APP_NAME.azurewebsites.net/api"
echo "   Frontend: Consulta en Azure Portal -> Static Web Apps"
