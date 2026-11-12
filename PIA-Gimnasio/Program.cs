using Microsoft.AspNetCore.Authentication.Cookies;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Logica;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages(options =>
{
    // Todas las páginas requieren autenticación por defecto, excepto Login
    options.Conventions.AuthorizeFolder("/");
    options.Conventions.AllowAnonymousToPage("/Login");
    options.Conventions.AllowAnonymousToPage("/AccessDenied");
    options.Conventions.AllowAnonymousToPage("/Error");
});

// Configuración de autenticación mediante Cookies
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Login";
        options.LogoutPath = "/Logout";
        options.AccessDeniedPath = "/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;
    });

builder.Services.AddAuthorization();

// Inyección de dependencias de la arquitectura por capas
builder.Services.AddScoped<bdConexion>();
builder.Services.AddScoped<logicaUsuario>();
builder.Services.AddScoped<logicaCliente>();
builder.Services.AddScoped<logicaSucursal>();
builder.Services.AddScoped<logicaSalon>();
builder.Services.AddScoped<logicaEmpleado>();
builder.Services.AddScoped<logicaPuesto>();
builder.Services.AddScoped<logicaMembresia>();
builder.Services.AddScoped<logicaClase>();
builder.Services.AddScoped<logicaControlAcceso>();
builder.Services.AddScoped<logicaReserva>();
builder.Services.AddScoped<logicaExpediente>();
builder.Services.AddScoped<logicaRutina>();
builder.Services.AddScoped<logicaReporte>();
builder.Services.AddScoped<logicaAuditoria>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();
app.MapRazorPages()
   .WithStaticAssets();

app.Run();
