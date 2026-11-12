using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Sucursales
{
    [Authorize(Roles = "Administrador")]
    public class IndexModel : PageModel
    {
        private readonly logicaSucursal _logica;

        public IndexModel(logicaSucursal logica)
        {
            _logica = logica;
        }

        [BindProperty]
        public bdSucursal Sucursal { get; set; } = new bdSucursal();

        [BindProperty(SupportsGet = true)]
        public string? Buscar { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        public DataTable Sucursales { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            CargarDatos();
        }

        public void OnGetEditar(short id)
        {
            Sucursal = _logica.Obtener(id) ?? new bdSucursal();
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Por favor verifica los campos obligatorios del formulario.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logica.Guardar(Sucursal, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                ModelState.Clear();
                Sucursal = new bdSucursal();
            }

            CargarDatos();
        }

        public void OnPostBaja(short id)
        {
            int idUsuario = ObtenerIdUsuario();
            var r = _logica.DarDeBaja(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            CargarDatos();
        }

        private void CargarDatos()
        {
            Sucursales = _logica.Consultar(Buscar, null, null, FiltroEstatus);
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
