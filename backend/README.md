# API REST de Tareas - .NET Core 8 Azure Functions

Esta API REST proporciona endpoints para la gestión de tareas con operaciones CRUD completas.

## Endpoints

### GET /api/tasks
Obtiene todas las tareas ordenadas por fecha de creación (más recientes primero).

**Respuesta:**
```json
[
  {
    "id": 1,
    "title": "Mi tarea",
    "description": "Descripción de la tarea",
    "status": 0,
    "createdAt": "2025-01-07T10:00:00Z",
    "updatedAt": "2025-01-07T10:00:00Z"
  }
]
```

### GET /api/tasks/{id}
Obtiene una tarea específica por su ID.

### POST /api/tasks
Crea una nueva tarea.

**Body:**
```json
{
  "title": "Nueva tarea",
  "description": "Descripción opcional",
  "status": 0
}
```

### PUT /api/tasks/{id}
Actualiza una tarea existente.

### DELETE /api/tasks/{id}
Elimina una tarea.

## Estados de Tarea

- `0` - Pendiente
- `1` - En Progreso
- `2` - Completada
- `3` - Cancelada

## Configuración Local

1. Instalar .NET 8 SDK
2. Instalar Azure Functions Core Tools
3. Configurar connection string en `local.settings.json`
4. Ejecutar: `func start`

## Despliegue

La API se despliega automáticamente en Azure Functions usando Terraform.
