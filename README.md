# Aplicación CRUD de Tareas - Serverless en Azure

Esta es una aplicación completa de gestión de tareas (CRUD) desarrollada con tecnologías modernas y desplegada en Azure usando una arquitectura serverless. La aplicación permite crear, leer, actualizar y eliminar tareas con una interfaz web moderna.

## 🏗️ Arquitectura de la Aplicación

- **Frontend**: Next.js 14 con TypeScript y Tailwind CSS
- **Backend**: .NET Core 8 como Azure Function App (API RESTful)
- **Base de Datos**: Azure SQL Database
- **Hosting**: Azure Static Web Apps para el frontend
- **Infraestructura**: Terraform para Infrastructure as Code

## 📁 Estructura del Proyecto

```
proyecto-infra-terraform-serverless-azure/
├── infrastructure/                 # Configuración de Terraform
│   ├── modules/
│   │   ├── function_app/          # Módulo Azure Function App
│   │   ├── static_web_app/        # Módulo Azure Static Web App
│   │   └── sql_server/            # Módulo Azure SQL Server
│   ├── main.tf                    # Configuración principal
│   ├── variables.tf               # Variables de Terraform
│   ├── outputs.tf                 # Outputs de la infraestructura
│   ├── providers.tf               # Configuración de proveedores
│   └── terraform.tfvars           # Valores de las variables
├── backend/                       # API .NET Core 8
│   ├── TaskApi/                   # Proyecto principal de la API
│   ├── TaskApi.Models/            # Modelos de datos
│   ├── TaskApi.Data/              # Contexto de Entity Framework
│   └── TaskApi.Tests/             # Pruebas unitarias
├── frontend/                      # Aplicación Next.js
│   ├── src/
│   │   ├── app/                   # App Router de Next.js 14
│   │   ├── components/            # Componentes reutilizables
│   │   ├── lib/                   # Utilidades y configuración
│   │   └── types/                 # Tipos de TypeScript
│   ├── public/                    # Archivos estáticos
│   └── package.json               # Dependencias del frontend
├── docs/                          # Documentación del proyecto
└── README.md                      # Este archivo
```

## 🚀 Funcionalidades

### API Backend (.NET Core 8)
- ✅ CRUD completo de tareas
- ✅ Validación de datos
- ✅ Entity Framework Core con SQL Server
- ✅ Swagger/OpenAPI para documentación
- ✅ Manejo de errores y logging
- ✅ CORS configurado para el frontend

### Frontend (Next.js 14)
- ✅ Interfaz moderna y responsiva
- ✅ Gestión de estado con React hooks
- ✅ Formularios con validación
- ✅ Integración con la API backend
- ✅ TypeScript para type safety
- ✅ Tailwind CSS para estilos

### Base de Datos
- ✅ Azure SQL Database
- ✅ Tabla de tareas con campos: ID, Título, Descripción, Estado, Fecha de creación/actualización
- ✅ Migraciones de Entity Framework

## 📚 Requisitos Previos

- ✅ [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- ✅ [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) configurado
- ✅ [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- ✅ [Node.js](https://nodejs.org/) >= 18
- ✅ [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)
- ✅ Cuenta de Azure con suscripción activa

## 🚀 Configuración y Despliegue

### 1. Clonar el Repositorio

```bash
git clone https://github.com/VillaviH/proyecto-infra-terraform-serverless-azure.git
cd proyecto-infra-terraform-serverless-azure
```

### 2. Configurar Variables de Terraform

Edita el archivo `infrastructure/terraform.tfvars` con tus valores:

```hcl
resource_group_name = "rg-crud-serverless-tuempresa"
location = "East US 2"

function_app_name = "crudappfunctiontuempresa"
function_app_storage_account_name = "crudappstoragetuempresa"
function_app_plan_name = "crudapplantuempresa"

static_web_app_name = "crudappstaticwebapptuempresa"
static_web_app_location = "frontend/out"

sql_server_name = "crudappsqltuempresa"
sql_admin_username = "sqladmin"
sql_admin_password = "TuPasswordSeguro123!"
database_name = "crudappdbtuempresa"
```

### 3. Desplegar la Infraestructura

```bash
cd infrastructure

# Inicializar Terraform
terraform init

# Revisar el plan
terraform plan

# Aplicar los cambios
terraform apply
```

### 4. Configurar el Backend (.NET Core 8)

```bash
cd ../backend

# Restaurar paquetes
dotnet restore

# Ejecutar localmente (opcional)
func start
```

### 5. Configurar el Frontend (Next.js)

```bash
cd ../frontend

# Instalar dependencias
npm install

# Configurar variable de entorno para producción
echo "NEXT_PUBLIC_API_URL=https://tu-function-app.azurewebsites.net/api" > .env.local

# Ejecutar en modo desarrollo
npm run dev

# Build para producción
npm run build
```

## 🔧 Desarrollo Local

### Backend
```bash
cd backend
func start
# La API estará disponible en http://localhost:7071
```

### Frontend
```bash
cd frontend
npm run dev
# La aplicación estará disponible en http://localhost:3000
```

## 📊 URLs de la Aplicación Desplegada

Después del despliegue exitoso, obtendrás:

- **API Backend**: `https://tu-function-app.azurewebsites.net/api`
- **Frontend**: `https://tu-static-web-app.azurestaticapps.net`
- **Base de Datos**: `tu-sql-server.database.windows.net`

## 🎯 Uso de la Aplicación

1. **Crear Tarea**: Haz clic en "Nueva Tarea" y completa el formulario
2. **Ver Tareas**: La lista principal muestra todas las tareas con sus estados
3. **Editar Tarea**: Haz clic en el ícono de edición (lápiz)
4. **Eliminar Tarea**: Haz clic en el ícono de eliminar (papelera)
5. **Estados**: Las tareas pueden estar Pendientes, En Progreso, Completadas o Canceladas

## 🛠️ Tecnologías Utilizadas

### Backend
- **Azure Functions** - Hosting serverless
- **.NET Core 8** - Framework principal
- **Entity Framework Core** - ORM para base de datos
- **Azure SQL Database** - Base de datos relacional

### Frontend
- **Next.js 14** - Framework React con App Router
- **TypeScript** - Tipado estático
- **Tailwind CSS** - Framework de estilos
- **Heroicons** - Iconografía
- **Azure Static Web Apps** - Hosting estático

### Infraestructura
- **Terraform** - Infrastructure as Code

### CI/CD
- **GitHub Actions** - Integración y despliegue continuo
- **Azure DevOps** - Pipelines de build y release
- **Automated Testing** - Pruebas automatizadas en cada push
- **Security Scanning** - Análisis de vulnerabilidades con Trivy y Checkov
- **Cost Estimation** - Estimación automática de costos con Infracost

## 🔄 CI/CD con GitHub Actions

Este proyecto incluye workflows automatizados de GitHub Actions para CI/CD:

### 🔨 Build and Test (`.github/workflows/build.yml`)
**Trigger**: Push y Pull Requests a `main` y `develop`
- ✅ Build del backend (.NET Core 8)
- ✅ Build del frontend (Next.js)
- ✅ Validación de infraestructura Terraform
- ✅ Análisis de seguridad con Trivy
- ✅ Tests automatizados
- ✅ Linting y formato de código

### 🚀 Deploy to Azure (`.github/workflows/deploy.yml`)
**Trigger**: Push a `main` branch
- ✅ Despliegue de infraestructura con Terraform
- ✅ Despliegue del backend a Azure Functions
- ✅ Despliegue del frontend a Azure Static Web Apps
- ✅ Health checks automatizados
- ✅ Notificaciones de estado

### 🏗️ Infrastructure Changes (`.github/workflows/infrastructure.yml`)
**Trigger**: Cambios en `infrastructure/` folder
- ✅ Plan de Terraform automático
- ✅ Aplicación controlada con aprobaciones
- ✅ Análisis de seguridad con Checkov
- ✅ Estimación de costos con Infracost
- ✅ Generación automática de documentación

### 🔧 Configuración Inicial de GitHub Actions

1. **Ejecutar script de configuración**:
   ```bash
   chmod +x scripts/setup-github-actions.sh
   ./scripts/setup-github-actions.sh
   ```

2. **Configuración manual** (si prefieres):
   - Sigue las instrucciones en `.github/workflows/secrets-template.md`
   - Configura los secrets requeridos en GitHub
   - Crea el environment `production` con reviewers

3. **Secrets requeridos**:
   - `AZURE_CREDENTIALS` - Credenciales del service principal
   - `SQL_CONNECTION_STRING` - Cadena de conexión de SQL Server
   - `AZURE_STATIC_WEB_APPS_API_TOKEN` - Token de Static Web Apps
   - `INFRACOST_API_KEY` - (Opcional) API key para estimación de costos

### 🎯 Flujo de Trabajo Recomendado

1. **Desarrollo**:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   # ... hacer cambios ...
   git push origin feature/nueva-funcionalidad
   ```
   ▶️ Se ejecuta automáticamente el workflow de **Build and Test**

2. **Pull Request**:
   - Crear PR hacia `main`
   - Revisar los checks automatizados
   - Aprobar y hacer merge

3. **Despliegue**:
   - Al hacer merge a `main`, se ejecuta automáticamente:
     - ▶️ **Deploy to Azure** workflow
     - ▶️ **Infrastructure Changes** workflow (si aplica)

4. **Monitoreo**:
   - Verificar health checks
   - Revisar logs en Azure Portal
   - Validar funcionalidad en la aplicación desplegada

## 📝 API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/tasks` | Obtener todas las tareas |
| GET | `/api/tasks/{id}` | Obtener tarea por ID |
| POST | `/api/tasks` | Crear nueva tarea |
| PUT | `/api/tasks/{id}` | Actualizar tarea |
| DELETE | `/api/tasks/{id}` | Eliminar tarea |

## 🔒 Seguridad

- Autenticación configurada en Azure Functions
- CORS habilitado para el frontend
- Connection strings almacenados de forma segura
- Validación de datos en backend y frontend

## 🧪 Testing

### Backend
```bash
cd backend
dotnet test
```

### Frontend
```bash
cd frontend
npm test
```

## 🚀 CI/CD

El proyecto está configurado para despliegue continuo:

1. **Push a main** → Ejecuta Terraform apply
2. **Cambios en backend** → Redespliega Azure Functions
3. **Cambios en frontend** → Redespliega Static Web App

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Si tienes problemas:

1. Revisa los logs de Azure Functions
2. Verifica las variables de entorno
3. Comprueba la conectividad de la base de datos
4. Abre un issue en GitHub

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

**Desarrollado con ❤️ usando Azure, .NET Core 8, Next.js y Terraform**