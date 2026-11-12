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
    [Authorize(Roles = "Administrador,Recepcionista")]
    public class IndexModel : PageModel
    {
        private readonly logicaMembresia _logicaMembresia;
        private readonly logicaCliente _logicaCliente;

        public IndexModel(logicaMembresia logicaMembresia, logicaCliente logicaCliente)
        {
            _logicaMembresia = logicaMembresia;
            _logicaCliente = logicaCliente;
        }

        [BindProperty]
        public bdSuscripcion Suscripcion { get; set; } = new bdSuscripcion();

        [BindProperty(SupportsGet = true)]
        public byte? FiltroPlan { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroCliente { get; set; }

        public DataTable Suscripciones { get; set; } = new DataTable();
        public DataTable Planes { get; set; } = new DataTable();
        public DataTable Clientes { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            CargarDatos();
        }

        public void OnGetEditar(int id)
        {
            Suscripcion = _logicaMembresia.ObtenerSuscripcion(id) ?? new bdSuscripcion();
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos de la suscripción.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaMembresia.GuardarSuscripcion(Suscripcion, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                ModelState.Clear();
                Suscripcion = new bdSuscripcion();
            }
            CargarDatos();
        }

        public void OnPostCancelar(int id)
        {
            int idUsuario = ObtenerIdUsuario();
            var r = _logicaMembresia.CancelarSuscripcion(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            CargarDatos();
        }

        private void CargarDatos()
        {
            Suscripciones = _logicaMembresia.ConsultarSuscripciones(FiltroCliente, FiltroPlan, FiltroEstatus);
            Planes = _logicaMembresia.ConsultarPlanes();
            Clientes = _logicaCliente.Consultar(null, null, 1); // Solo clientes activos para asignación
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
