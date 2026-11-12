using System;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Salones
{
    [Authorize(Roles = "Administrador")]
    public class IndexModel : PageModel
    {
        private readonly logicaSalon _logicaSalon;
        private readonly logicaSucursal _logicaSucursal;

        public IndexModel(logicaSalon logicaSalon, logicaSucursal logicaSucursal)
        {
            _logicaSalon = logicaSalon;
            _logicaSucursal = logicaSucursal;
        }

        [BindProperty]
        public bdSalon Salon { get; set; } = new bdSalon();

        [BindProperty(SupportsGet = true)]
        public short? IdSucursal { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? Buscar { get; set; }

        public DataTable Salones { get; set; } = new DataTable();
        public DataTable Sucursales { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            if (IdSucursal.HasValue && IdSucursal.Value > 0)
            {
                Salon.IdSucursal = IdSucursal.Value;
            }
            CargarDatos();
        }

        public void OnGetEditar(int id)
        {
            Salon = _logicaSalon.Obtener(id) ?? new bdSalon();
            IdSucursal = Salon.IdSucursal;
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos obligatorios del salón.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaSalon.Guardar(Salon, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                short sucursalActual = Salon.IdSucursal;
                ModelState.Clear();
                Salon = new bdSalon { IdSucursal = sucursalActual };
            }

            CargarDatos();
        }

        public void OnPostBaja(int id)
        {
            int idUsuario = ObtenerIdUsuario();
            var r = _logicaSalon.DarDeBaja(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            CargarDatos();
        }

        private void CargarDatos()
        {
            Sucursales = _logicaSucursal.Consultar();
            Salones = _logicaSalon.Consultar(IdSucursal, FiltroEstatus, Buscar);
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
