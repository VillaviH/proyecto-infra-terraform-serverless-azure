# 🔐 GitHub Secrets Configuration

## Secrets requeridos para el CI/CD

Configure estos secrets en `Settings > Secrets and variables > Actions` de su repositorio GitHub:

### 🔑 Azure Authentication
```bash
AZURE_CREDENTIALS
```
**Descripción**: Credenciales de Azure en formato JSON
**Obtener**: Ejecutar en Azure CLI:
```bash
az ad sp create-for-rbac --name "github-actions-crud-app" \
  --role contributor \
  --scopes /subscriptions/{subscription-id} \
  --sdk-auth
```

### 🗄️ Database Connection
```bash
SQL_CONNECTION_STRING
```
**Descripción**: Cadena de conexión a SQL Server
**Formato**: 
```
Server=tcp:{server-name}.database.windows.net,1433;Initial Catalog={database-name};Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

### 🌐 Static Web Apps
```bash
AZURE_STATIC_WEB_APPS_API_TOKEN
```
**Descripción**: Token de despliegue para Static Web Apps
**Obtener**: En Azure Portal > Static Web Apps > Manage deployment token

### 💰 Cost Estimation (Opcional)
```bash
INFRACOST_API_KEY
```
**Descripción**: API Key para Infracost (estimación de costos)
**Obtener**: Registrarse en https://www.infracost.io/

## Variables de Environment

### Production Environment
Configurar en `Settings > Environments > production`:

- **Reviewers**: Agregar usuarios que deben aprobar despliegues
- **Deployment branches**: `main` branch only
- **Environment secrets**: Usar los mismos secrets configurados arriba

## Scripts de configuración

### Configurar Azure Credentials
```bash
# 1. Login a Azure
az login

# 2. Obtener subscription ID
az account list --output table

# 3. Crear service principal
az ad sp create-for-rbac --name "github-actions-crud-app" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth

# 4. Copiar el output JSON completo a AZURE_CREDENTIALS secret
```

### Configurar SQL Connection String
```bash
# Después del despliegue de Terraform, obtener la cadena de conexión:
cd infrastructure
terraform output sql_connection_string
```

### Configurar Static Web Apps Token
```bash
# Obtener el token después del despliegue:
cd infrastructure
terraform output static_web_app_api_key
```

## Verificación de configuración

Para verificar que todos los secrets están configurados correctamente:

1. Ve a `Settings > Secrets and variables > Actions`
2. Verifica que existen estos secrets:
   - ✅ AZURE_CREDENTIALS
   - ✅ SQL_CONNECTION_STRING  
   - ✅ AZURE_STATIC_WEB_APPS_API_TOKEN
   - ⚪ INFRACOST_API_KEY (opcional)

3. Ve a `Settings > Environments`
4. Verifica que existe el environment `production` con:
   - ✅ Required reviewers configurados
   - ✅ Deployment branches: `main` only

## Troubleshooting

### Error: "Resource 'Microsoft.Web/sites' was disallowed by policy"
- Verificar que el service principal tiene permisos de Contributor
- Verificar que no hay políticas de Azure Policy bloqueando la creación

### Error: "Authentication failed"
- Verificar que AZURE_CREDENTIALS está en formato JSON válido
- Verificar que el service principal no ha expirado

### Error: "SQL connection failed"
- Verificar que SQL_CONNECTION_STRING incluye credenciales válidas
- Verificar que el firewall de SQL Server permite conexiones desde Azure
