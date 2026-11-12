using System;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Membresias
{
    [Authorize(Roles = "Administrador")]
    public class PlanesModel : PageModel
    {
        private readonly logicaMembresia _logica;

        public PlanesModel(logicaMembresia logica)
        {
            _logica = logica;
        }

        [BindProperty]
        public bdMembresia Plan { get; set; } = new bdMembresia();

        public DataTable Planes { get; set; } = new DataTable();
        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            CargarDatos();
        }

        public void OnGetEditar(byte id)
        {
            Plan = _logica.ObtenerPlan(id) ?? new bdMembresia();
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos de la membresía.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logica.GuardarPlan(Plan, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                ModelState.Clear();
                Plan = new bdMembresia();
            }
            CargarDatos();
        }

        private void CargarDatos()
        {
            Planes = _logica.ConsultarPlanes();
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
