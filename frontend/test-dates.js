// Test script para verificar las funciones de fecha
import { formatDate, formatDateTime, formatRelativeTime } from './src/lib/dateUtils';

// Simular algunos ejemplos de fechas del backend
const testDates = [
  '2024-07-08T20:00:00.000Z',
  '2024-07-08T18:30:00.000Z', 
  '2024-07-07T12:00:00.000Z',
  '2024-07-01T10:00:00.000Z',
  null,
  undefined,
  'invalid-date'
];

console.log('=== Test de funciones de fecha ===');

testDates.forEach((date, index) => {
  console.log(`\nTest ${index + 1}: ${date || 'null/undefined'}`);
  console.log(`formatDate: ${formatDate(date)}`);
  console.log(`formatDateTime: ${formatDateTime(date)}`);
  console.log(`formatRelativeTime: ${formatRelativeTime(date)}`);
});
