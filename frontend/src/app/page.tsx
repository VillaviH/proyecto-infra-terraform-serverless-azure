'use client';

import { useState, useEffect } from 'react';
import { TaskItem, TaskStatus, TaskStatusLabels, TaskStatusColors } from '@/types/task';
import { taskService } from '@/lib/taskService';
import { formatDate, formatRelativeTime } from '@/lib/dateUtils';
import TaskForm from '@/components/TaskForm';
import { PlusIcon, PencilIcon, TrashIcon } from '@heroicons/react/24/outline';

export default function TaskPage() {
  const [tasks, setTasks] = useState<TaskItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [editingTask, setEditingTask] = useState<TaskItem | null>(null);

  useEffect(() => {
    loadTasks();
  }, []);

  const loadTasks = async () => {
    try {
      setLoading(true);
      const data = await taskService.getTasks();
      setTasks(data);
      setError(null);
    } catch (err) {
      setError('Error al cargar las tareas');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateTask = async (taskData: Omit<TaskItem, 'id' | 'createdAt' | 'updatedAt'>) => {
    try {
      console.log('Creating task with form data:', taskData); // Debug log
      
      // Validar que el título no esté vacío
      if (!taskData.title || !taskData.title.trim()) {
        setError('El título es requerido');
        return;
      }
      
      // Para crear, solo enviamos title y description
      await taskService.createTask({
        title: taskData.title.trim(),
        description: taskData.description?.trim() || undefined
      });
      
      await loadTasks();
      setShowForm(false);
      setError(null); // Limpiar error en éxito
    } catch (err) {
      console.error('Error in handleCreateTask:', err);
      setError('Error al crear la tarea');
    }
  };

  const handleUpdateTask = async (taskData: Omit<TaskItem, 'id' | 'createdAt' | 'updatedAt'>) => {
    if (!editingTask) return;
    
    try {
      await taskService.updateTask(editingTask.id, taskData);
      await loadTasks();
      setEditingTask(null);
      setShowForm(false);
    } catch (err) {
      setError('Error al actualizar la tarea');
      console.error(err);
    }
  };

  const handleDeleteTask = async (id: number) => {
    if (!confirm('¿Estás seguro de que quieres eliminar esta tarea?')) return;
    
    try {
      await taskService.deleteTask(id);
      await loadTasks();
    } catch (err) {
      setError('Error al eliminar la tarea');
      console.error(err);
    }
  };

  const openEditForm = (task: TaskItem) => {
    setEditingTask(task);
    setShowForm(true);
  };

  const closeForm = () => {
    setShowForm(false);
    setEditingTask(null);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-lg">Cargando tareas...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header principal con tecnologías */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            📝 Gestión de Tareas CRUD ...
          </h1>
          <p className="text-lg text-gray-600 mb-4">
            Aplicación serverless completa con tecnologías modernas
          </p>
          <div className="flex justify-center items-center space-x-4 text-sm text-gray-500 bg-white py-3 px-6 rounded-lg shadow-sm">
            <span className="flex items-center">
              ⚛️ <span className="ml-1">React/Next.js</span>
            </span>
            <span>•</span>
            <span className="flex items-center">
              🔷 <span className="ml-1">TypeScript</span>
            </span>
            <span>•</span>
            <span className="flex items-center">
              🎨 <span className="ml-1">Tailwind CSS</span>
            </span>
            <span>•</span>
            <span className="flex items-center">
              💜 <span className="ml-1">.NET Core</span>
            </span>
            <span>•</span>
            <span className="flex items-center">
              ⚡ <span className="ml-1">Azure Functions</span>
            </span>
            <span>•</span>
            <span className="flex items-center">
              🗄️ <span className="ml-1">SQL Server</span>
            </span>
            <span>•</span>
            <span className="flex items-center">
              🏗️ <span className="ml-1">Terraform</span>
            </span>
          </div>
        </div>

        <div className="bg-white shadow rounded-lg">
          {/* Header de la sección de tareas */}
          <div className="px-6 py-4 border-b border-gray-200">
            <div className="flex justify-between items-center">
              <h2 className="text-2xl font-bold text-gray-900">📋 Mis Tareas</h2>
              <button
                onClick={() => setShowForm(true)}
                className="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
              >
                <PlusIcon className="h-5 w-5 mr-2" />
                Nueva Tarea
              </button>
            </div>
          </div>

          {/* Error Message */}
          {error && (
            <div className="mx-6 mt-4 p-4 bg-red-50 border border-red-200 rounded-md">
              <p className="text-red-800">{error}</p>
            </div>
          )}

          {/* Task List */}
          <div className="p-6">
            {tasks.length === 0 ? (
              <div className="text-center py-12">
                <div className="text-6xl mb-4">📋</div>
                <p className="text-gray-500 text-xl mb-2">¡No hay tareas disponibles!</p>
                <p className="text-gray-400 mb-6">Crea tu primera tarea para comenzar a organizar tu trabajo</p>
                <button
                  onClick={() => setShowForm(true)}
                  className="inline-flex items-center px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
                >
                  <PlusIcon className="h-5 w-5 mr-2" />
                  Crear Primera Tarea
                </button>
              </div>
            ) : (
              <div className="space-y-4">
                {tasks.map((task) => (
                  <div
                    key={task.id}
                    className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow"
                  >
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <h3 className="text-lg font-medium text-gray-900">{task.title}</h3>
                        {task.description && (
                          <p className="text-gray-600 mt-1">{task.description}</p>
                        )}
                        <div className="flex items-center mt-3 space-x-4 text-sm text-gray-500">
                          <span
                            className={`inline-flex px-2 py-1 text-xs font-medium rounded-full ${
                              TaskStatusColors[task.status]
                            }`}
                          >
                            {TaskStatusLabels[task.status]}
                          </span>
                          <span title={`Creada el ${formatDate(task.createdAt)}`}>
                            Creada: {formatRelativeTime(task.createdAt)}
                          </span>
                          {task.updatedAt !== task.createdAt && (
                            <span title={`Actualizada el ${formatDate(task.updatedAt)}`}>
                              • Actualizada: {formatRelativeTime(task.updatedAt)}
                            </span>
                          )}
                        </div>
                      </div>
                      <div className="flex space-x-2 ml-4">
                        <button
                          onClick={() => openEditForm(task)}
                          className="p-2 text-gray-400 hover:text-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded"
                        >
                          <PencilIcon className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => handleDeleteTask(task.id)}
                          className="p-2 text-gray-400 hover:text-red-600 focus:outline-none focus:ring-2 focus:ring-red-500 rounded"
                        >
                          <TrashIcon className="h-5 w-5" />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Task Form Modal */}
      {showForm && (
        <TaskForm
          task={editingTask}
          onSubmit={editingTask ? handleUpdateTask : handleCreateTask}
          onCancel={closeForm}
        />
      )}
    </div>
  );
}
