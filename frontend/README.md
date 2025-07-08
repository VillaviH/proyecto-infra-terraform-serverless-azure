# Frontend de Gestión de Tareas - Next.js 14

Aplicación web moderna para la gestión de tareas construida con Next.js 14, TypeScript y Tailwind CSS.

## Características

- ✅ Interfaz moderna y responsiva
- ✅ Gestión completa de tareas (CRUD)
- ✅ Estados visuales de tareas
- ✅ Formularios con validación
- ✅ TypeScript para type safety
- ✅ Tailwind CSS para estilos
- ✅ Optimizado para Azure Static Web Apps

## Desarrollo Local

1. Instalar dependencias:
```bash
npm install
```

2. Configurar variables de entorno:
```bash
# .env.local
NEXT_PUBLIC_API_URL=http://localhost:7071/api
```

3. Ejecutar en modo desarrollo:
```bash
npm run dev
```

4. Abrir [http://localhost:3000](http://localhost:3000)

## Build para Producción

```bash
npm run build
```

El output estático se genera en la carpeta `out/` y está listo para ser desplegado en Azure Static Web Apps.

## Estructura de Componentes

- `src/app/page.tsx` - Página principal con lista de tareas
- `src/components/TaskForm.tsx` - Formulario de crear/editar tareas
- `src/lib/taskService.ts` - Servicio para comunicación con la API
- `src/types/task.ts` - Tipos TypeScript para tareas

## Integración con la API

La aplicación se conecta automáticamente con la API de Azure Functions usando la variable de entorno `NEXT_PUBLIC_API_URL`.
