# 🚀 Guía de Despliegue Automático

## 📝 Flujo de Trabajo para Cambios en Frontend

### Opción 1: Script Manual (Inmediato)
```bash
# Desde el directorio frontend/
cd frontend
../scripts/auto-deploy.sh
```

### Opción 2: GitHub Actions (Automático)
```bash
# Hacer commit y push de cambios
git add .
git commit -m "feat: descripción de cambios"
git push origin main
```

### Opción 3: Script Directo
```bash
# Desde el directorio raíz
./scripts/deploy-frontend.sh
```

## 🔧 Configuración de Secrets (Una sola vez)

### GitHub Secrets Requeridos:
- `AZURE_STATIC_WEB_APPS_API_TOKEN`: Token de Azure Static Web Apps
- `AZURE_CREDENTIALS`: Credenciales del Service Principal
- `SQL_CONNECTION_STRING`: Cadena de conexión de SQL Server

### Obtener Token de Static Web Apps:
```bash
az staticwebapp secrets list \
  --name crudappstaticwebappdatafast \
  --resource-group rg-crud-serverless-datafast \
  --query "properties.apiKey" -o tsv
```

## 🐛 Solución de Problemas

### Si no se actualizan los cambios:
1. Verificar que el build se completó sin errores
2. Esperar 2-3 minutos para propagación de CDN
3. Limpiar caché del navegador (Ctrl+F5)
4. Verificar logs en Azure Portal

### Si GitHub Actions falla:
1. Verificar que los secrets están configurados
2. Revisar los logs del workflow en GitHub
3. Verificar permisos del Service Principal

## 📋 URLs Importantes

- **Frontend**: https://crudappstaticwebappdatafast.azurestaticapps.net
- **Backend API**: https://crudappfunctiondatafast.azurewebsites.net/api
- **Azure Portal**: https://portal.azure.com
- **GitHub Actions**: https://github.com/TU_USUARIO/TU_REPO/actions

## 🔄 Comandos Útiles

```bash
# Ver status del repositorio
git status

# Build local para testing
npm run build

# Verificar salud del backend
curl https://crudappfunctiondatafast.azurewebsites.net/api/tasks

# Ver logs de Azure Functions
az functionapp logs tail --name crudappfunctiondatafast --resource-group rg-crud-serverless-datafast
```
