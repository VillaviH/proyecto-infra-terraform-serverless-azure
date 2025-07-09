/**
 * Utility functions for date formatting and manipulation
 */

/**
 * Formats a date string to a localized date string
 * @param dateString - ISO date string from the API
 * @param locale - Locale for formatting (default: 'es-ES')
 * @returns Formatted date string or 'Fecha inválida' if parsing fails
 */
export function formatDate(dateString: string | null | undefined, locale: string = 'es-ES'): string {
  if (!dateString) {
    return 'Sin fecha';
  }

  try {
    // Ensure the date string is in a proper format
    const date = new Date(dateString);
    
    // Check if the date is valid
    if (isNaN(date.getTime())) {
      console.warn('Invalid date string:', dateString);
      return 'Fecha inválida';
    }

    return date.toLocaleDateString(locale, {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  } catch (error) {
    console.error('Error parsing date:', dateString, error);
    return 'Fecha inválida';
  }
}

/**
 * Formats a date string to a localized date and time string
 * @param dateString - ISO date string from the API
 * @param locale - Locale for formatting (default: 'es-ES')
 * @returns Formatted date and time string
 */
export function formatDateTime(dateString: string | null | undefined, locale: string = 'es-ES'): string {
  if (!dateString) {
    return 'Sin fecha';
  }

  try {
    const date = new Date(dateString);
    
    if (isNaN(date.getTime())) {
      console.warn('Invalid date string:', dateString);
      return 'Fecha inválida';
    }

    return date.toLocaleString(locale, {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  } catch (error) {
    console.error('Error parsing date:', dateString, error);
    return 'Fecha inválida';
  }
}

/**
 * Formats a date string to a relative time string (e.g., "hace 2 horas")
 * @param dateString - ISO date string from the API
 * @returns Relative time string
 */
export function formatRelativeTime(dateString: string | null | undefined): string {
  if (!dateString) {
    return 'Sin fecha';
  }

  try {
    const date = new Date(dateString);
    
    if (isNaN(date.getTime())) {
      return 'Fecha inválida';
    }

    const now = new Date();
    const diffInSeconds = Math.floor((now.getTime() - date.getTime()) / 1000);

    // Less than a minute
    if (diffInSeconds < 60) {
      return 'Hace unos segundos';
    }

    // Less than an hour
    if (diffInSeconds < 3600) {
      const minutes = Math.floor(diffInSeconds / 60);
      return `Hace ${minutes} minuto${minutes !== 1 ? 's' : ''}`;
    }

    // Less than a day
    if (diffInSeconds < 86400) {
      const hours = Math.floor(diffInSeconds / 3600);
      return `Hace ${hours} hora${hours !== 1 ? 's' : ''}`;
    }

    // Less than a week
    if (diffInSeconds < 604800) {
      const days = Math.floor(diffInSeconds / 86400);
      return `Hace ${days} día${days !== 1 ? 's' : ''}`;
    }

    // Fall back to regular date format
    return formatDate(dateString);
  } catch (error) {
    console.error('Error calculating relative time:', dateString, error);
    return 'Fecha inválida';
  }
}
