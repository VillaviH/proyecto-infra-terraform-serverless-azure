# Script de despliegue automatizado
# Usar después de terraform apply

# Configurar variables
$functionAppName = "crudappfunctiondatafast"
$staticWebAppName = "crudappstaticwebappdatafast"
$resourceGroupName = "rg-crud-serverless-datafast"

Write-Host "🚀 Iniciando despliegue de la aplicación CRUD de tareas..."

# 1. Deploy del backend (Azure Functions)
Write-Host "📦 Desplegando Backend (.NET Core 8)..."
Set-Location backend
dotnet publish --configuration Release --output ./publish
Compress-Archive -Path ./publish/* -DestinationPath ./function-app.zip -Force
az functionapp deployment source config-zip --resource-group $resourceGroupName --name $functionAppName --src ./function-app.zip
Remove-Item ./function-app.zip

# 2. Deploy del frontend (Next.js)
Write-Host "🌐 Desplegando Frontend (Next.js)..."
Set-Location ../frontend
npm install
npm run build

# 3. Configurar Static Web App
az staticwebapp environment set --name $staticWebAppName --environment-name default --api-location "backend" --app-location "frontend/out"

Write-Host "✅ Despliegue completado!"
Write-Host "🔗 URLs de la aplicación:"
Write-Host "   Backend API: https://$functionAppName.azurewebsites.net/api"
Write-Host "   Frontend: Consulta en Azure Portal -> Static Web Apps"
