using Microsoft.Azure.Functions.Worker;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TaskApi.Data;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices(services =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
        
        // Configurar Entity Framework
        var connectionString = Environment.GetEnvironmentVariable("SqlConnectionString") ??
            throw new InvalidOperationException("SqlConnectionString no está configurada");
            
        services.AddDbContext<TaskDbContext>(options =>
            options.UseSqlServer(connectionString));
    })
    .Build();

// Asegurar que la base de datos existe y está actualizada
using (var scope = host.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<TaskDbContext>();
    await context.Database.EnsureCreatedAsync();
}

host.Run();
