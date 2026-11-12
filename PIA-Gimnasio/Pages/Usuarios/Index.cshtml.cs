using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Usuarios
{
    [Authorize(Roles = "Administrador")]
    public class IndexModel : PageModel
    {
        private readonly logicaUsuario _logicaUsuario;
        private readonly logicaEmpleado _logicaEmpleado;

        public IndexModel(logicaUsuario logicaUsuario, logicaEmpleado logicaEmpleado)
        {
            _logicaUsuario = logicaUsuario;
            _logicaEmpleado = logicaEmpleado;
        }

        [BindProperty(SupportsGet = true)]
        public string? FiltroNombre { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroRol { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        public List<bdUsuario> Usuarios { get; set; } = new List<bdUsuario>();
        public List<bdRol> Roles { get; set; } = new List<bdRol>();
        public DataTable Empleados { get; set; } = new DataTable();

        // Form Crear
        [BindProperty]
        public string NombreCuentaCrear { get; set; } = "";

        [BindProperty]
        public string ContrasenaCrear { get; set; } = "";

        [BindProperty]
        public byte IdRolCrear { get; set; }

        [BindProperty]
        public int IdEmpleadoCrear { get; set; }

        [BindProperty]
        public byte IdEstatusCrear { get; set; } = 1;

        // Form Modificar Rol/Estatus
        [BindProperty]
        public int IdUsuarioModificar { get; set; }

        [BindProperty]
        public byte IdRolModificar { get; set; }

        [BindProperty]
        public byte IdEstatusModificar { get; set; }

        // Form Cambiar Contraseña
        [BindProperty]
        public int IdUsuarioPassword { get; set; }

        [BindProperty]
        public string NuevaContrasena { get; set; } = "";

        [TempData]
        public string Mensaje { get; set; } = "";

        [TempData]
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            CargarDatos();
        }

        public IActionResult OnPostCrear()
        {
            if (string.IsNullOrWhiteSpace(NombreCuentaCrear) || string.IsNullOrWhiteSpace(ContrasenaCrear)
                || IdRolCrear <= 0 || IdEmpleadoCrear <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Todos los campos para la creación de cuenta son obligatorios.";
                return RedirectToPage(new { FiltroNombre, FiltroRol, FiltroEstatus });
            }

            var resp = _logicaUsuario.Crear(NombreCuentaCrear, ContrasenaCrear, IdRolCrear, IdEmpleadoCrear, IdEstatusCrear, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { FiltroNombre = NombreCuentaCrear });
        }

        public IActionResult OnPostModificar()
        {
            if (IdUsuarioModificar <= 0 || IdRolModificar <= 0 || IdEstatusModificar <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Parámetros de modificación de usuario inválidos.";
                return RedirectToPage(new { FiltroNombre, FiltroRol, FiltroEstatus });
            }

            var resp = _logicaUsuario.Modificar(IdUsuarioModificar, IdRolModificar, IdEstatusModificar, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { FiltroNombre, FiltroRol, FiltroEstatus });
        }

        public IActionResult OnPostCambiarContrasena()
        {
            if (IdUsuarioPassword <= 0 || string.IsNullOrWhiteSpace(NuevaContrasena))
            {
                TipoMensaje = "warning";
                Mensaje = "Debes ingresar la nueva contraseña.";
                return RedirectToPage(new { FiltroNombre, FiltroRol, FiltroEstatus });
            }

            var resp = _logicaUsuario.CambiarContrasena(IdUsuarioPassword, NuevaContrasena, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { FiltroNombre, FiltroRol, FiltroEstatus });
        }

        private void CargarDatos()
        {
            Usuarios = _logicaUsuario.Consultar(FiltroNombre, FiltroRol, FiltroEstatus);
            Roles = _logicaUsuario.ConsultarRoles();
            Empleados = _logicaEmpleado.Consultar(null, null, 1); // Empleados activos
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
