export interface TaskItem {
  id: number;
  title: string;
  description?: string;
  status: TaskStatus;
  createdAt: string;
  updatedAt: string;
}

export enum TaskStatus {
  Pending = 0,
  InProgress = 1,
  Completed = 2,
  Cancelled = 3
}

export const TaskStatusLabels = {
  [TaskStatus.Pending]: '⏳ Pendiente',
  [TaskStatus.InProgress]: '🔄 En Progreso',
  [TaskStatus.Completed]: '✅ Completada',
  [TaskStatus.Cancelled]: '❌ Cancelada'
};

export const TaskStatusColors = {
  [TaskStatus.Pending]: 'bg-yellow-100 text-yellow-800',
  [TaskStatus.InProgress]: 'bg-blue-100 text-blue-800',
  [TaskStatus.Completed]: 'bg-green-100 text-green-800',
  [TaskStatus.Cancelled]: 'bg-red-100 text-red-800'
};
