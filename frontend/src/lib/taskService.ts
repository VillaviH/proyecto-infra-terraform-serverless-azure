import { TaskItem } from '@/types/task';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:7071/api';

export const taskService = {
  // Obtener todas las tareas
  async getTasks(): Promise<TaskItem[]> {
    const response = await fetch(`${API_BASE_URL}/tasks`);
    if (!response.ok) {
      throw new Error('Error al obtener las tareas');
    }
    return response.json();
  },

  // Obtener tarea por ID
  async getTaskById(id: number): Promise<TaskItem> {
    const response = await fetch(`${API_BASE_URL}/tasks/${id}`);
    if (!response.ok) {
      throw new Error('Error al obtener la tarea');
    }
    return response.json();
  },

  // Crear nueva tarea
  async createTask(task: { title: string; description?: string }): Promise<TaskItem> {
    console.log('Creating task with data:', task); // Debug log
    
    // El backend espera un TaskItem con propiedades en PascalCase
    const requestBody = {
      Title: task.title,
      Description: task.description || null,
      Status: 0, // TaskStatus.Pending
      CreatedAt: new Date().toISOString(),
      UpdatedAt: new Date().toISOString()
    };
    
    console.log('Request body:', requestBody); // Debug log
    
    const response = await fetch(`${API_BASE_URL}/tasks`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(requestBody),
    });
    
    if (!response.ok) {
      const errorText = await response.text();
      console.error('Error creating task:', response.status, errorText);
      throw new Error(`Error al crear la tarea: ${errorText}`);
    }
    return response.json();
  },

  // Actualizar tarea
  async updateTask(id: number, task: Omit<TaskItem, 'id' | 'createdAt' | 'updatedAt'>): Promise<TaskItem> {
    const response = await fetch(`${API_BASE_URL}/tasks/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        Title: task.title,
        Description: task.description || null,
        Status: task.status
      }),
    });
    if (!response.ok) {
      const errorText = await response.text();
      console.error('Error updating task:', response.status, errorText);
      throw new Error('Error al actualizar la tarea');
    }
    return response.json();
  },

  // Eliminar tarea
  async deleteTask(id: number): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/tasks/${id}`, {
      method: 'DELETE',
    });
    if (!response.ok) {
      throw new Error('Error al eliminar la tarea');
    }
  },
};
