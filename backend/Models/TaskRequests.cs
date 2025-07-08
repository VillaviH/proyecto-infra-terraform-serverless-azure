using System.ComponentModel.DataAnnotations;

namespace TaskCrudApi.Models;

public class CreateTaskRequest
{
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = string.Empty;
    
    [StringLength(1000)]
    public string? Description { get; set; }
    
    public Priority Priority { get; set; } = Priority.Medium;
}

public class UpdateTaskRequest
{
    [StringLength(200)]
    public string? Title { get; set; }
    
    [StringLength(1000)]
    public string? Description { get; set; }
    
    public bool? IsCompleted { get; set; }
    
    public Priority? Priority { get; set; }
}
