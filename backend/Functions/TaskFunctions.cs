using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Text.Json;
using TaskApi.Data;
using TaskApi.Models;

namespace TaskApi.Functions;

public class TaskFunctions
{
    private readonly TaskDbContext _context;
    private readonly ILogger<TaskFunctions> _logger;

    public TaskFunctions(TaskDbContext context, ILogger<TaskFunctions> logger)
    {
        _context = context;
        _logger = logger;
    }

    [Function("GetTasks")]
    public async Task<HttpResponseData> GetTasks(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "tasks")] HttpRequestData req)
    {
        try
        {
            var tasks = await _context.Tasks.OrderByDescending(t => t.CreatedAt).ToListAsync();
            
            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "application/json");
            
            await response.WriteStringAsync(JsonSerializer.Serialize(tasks));
            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener las tareas");
            
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Error interno del servidor" }));
            return errorResponse;
        }
    }

    [Function("GetTaskById")]
    public async Task<HttpResponseData> GetTaskById(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "tasks/{id:int}")] HttpRequestData req,
        int id)
    {
        try
        {
            var task = await _context.Tasks.FindAsync(id);
            
            if (task == null)
            {
                var notFoundResponse = req.CreateResponse(HttpStatusCode.NotFound);
                await notFoundResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Tarea no encontrada" }));
                return notFoundResponse;
            }

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "application/json");
            
            await response.WriteStringAsync(JsonSerializer.Serialize(task));
            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener la tarea {TaskId}", id);
            
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Error interno del servidor" }));
            return errorResponse;
        }
    }

    [Function("CreateTask")]
    public async Task<HttpResponseData> CreateTask(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "tasks")] HttpRequestData req)
    {
        try
        {
            var body = await req.ReadAsStringAsync();
            var task = JsonSerializer.Deserialize<TaskItem>(body ?? string.Empty);
            
            if (task == null || string.IsNullOrWhiteSpace(task.Title))
            {
                var badRequestResponse = req.CreateResponse(HttpStatusCode.BadRequest);
                await badRequestResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Título es requerido" }));
                return badRequestResponse;
            }

            task.Id = 0; // Asegurar que EF genere un nuevo ID
            task.CreatedAt = DateTime.UtcNow;
            task.UpdatedAt = DateTime.UtcNow;

            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();

            var response = req.CreateResponse(HttpStatusCode.Created);
            response.Headers.Add("Content-Type", "application/json");
            
            await response.WriteStringAsync(JsonSerializer.Serialize(task));
            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al crear la tarea");
            
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Error interno del servidor" }));
            return errorResponse;
        }
    }

    [Function("UpdateTask")]
    public async Task<HttpResponseData> UpdateTask(
        [HttpTrigger(AuthorizationLevel.Anonymous, "put", Route = "tasks/{id:int}")] HttpRequestData req,
        int id)
    {
        try
        {
            var existingTask = await _context.Tasks.FindAsync(id);
            
            if (existingTask == null)
            {
                var notFoundResponse = req.CreateResponse(HttpStatusCode.NotFound);
                await notFoundResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Tarea no encontrada" }));
                return notFoundResponse;
            }

            var body = await req.ReadAsStringAsync();
            var updatedTask = JsonSerializer.Deserialize<TaskItem>(body ?? string.Empty);
            
            if (updatedTask == null || string.IsNullOrWhiteSpace(updatedTask.Title))
            {
                var badRequestResponse = req.CreateResponse(HttpStatusCode.BadRequest);
                await badRequestResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Título es requerido" }));
                return badRequestResponse;
            }

            existingTask.Title = updatedTask.Title;
            existingTask.Description = updatedTask.Description;
            existingTask.Status = updatedTask.Status;
            existingTask.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "application/json");
            
            await response.WriteStringAsync(JsonSerializer.Serialize(existingTask));
            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al actualizar la tarea {TaskId}", id);
            
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Error interno del servidor" }));
            return errorResponse;
        }
    }

    [Function("DeleteTask")]
    public async Task<HttpResponseData> DeleteTask(
        [HttpTrigger(AuthorizationLevel.Anonymous, "delete", Route = "tasks/{id:int}")] HttpRequestData req,
        int id)
    {
        try
        {
            var task = await _context.Tasks.FindAsync(id);
            
            if (task == null)
            {
                var notFoundResponse = req.CreateResponse(HttpStatusCode.NotFound);
                await notFoundResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Tarea no encontrada" }));
                return notFoundResponse;
            }

            _context.Tasks.Remove(task);
            await _context.SaveChangesAsync();

            var response = req.CreateResponse(HttpStatusCode.NoContent);
            return response;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al eliminar la tarea {TaskId}", id);
            
            var errorResponse = req.CreateResponse(HttpStatusCode.InternalServerError);
            await errorResponse.WriteStringAsync(JsonSerializer.Serialize(new { error = "Error interno del servidor" }));
            return errorResponse;
        }
    }
}
