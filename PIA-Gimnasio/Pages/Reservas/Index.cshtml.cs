using System;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Reservas
{
    [Authorize(Roles = "Administrador,Recepcionista,Entrenador")]
    public class IndexModel : PageModel
    {
        private readonly logicaReserva _logicaReserva;
        private readonly logicaClase _logicaClase;
        private readonly logicaCliente _logicaCliente;

        public IndexModel(logicaReserva logicaReserva, logicaClase logicaClase, logicaCliente logicaCliente)
        {
            _logicaReserva = logicaReserva;
            _logicaClase = logicaClase;
            _logicaCliente = logicaCliente;
        }

        [BindProperty]
        public int IdClaseReserva { get; set; }

        [BindProperty]
        public int IdClienteReserva { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroClase { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroCliente { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        public DataTable Reservas { get; set; } = new DataTable();
        public DataTable Clases { get; set; } = new DataTable();
        public DataTable Socios { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public bool EsEntrenador => User.IsInRole("Entrenador");
        public bool PuedeInscribir => User.IsInRole("Administrador") || User.IsInRole("Recepcionista");
        public bool PuedeTomarAsistencia => User.IsInRole("Administrador") || User.IsInRole("Entrenador");

        public void OnGet()
        {
            CargarDatos();
        }

        public IActionResult OnPostInscribir()
        {
            if (!PuedeInscribir)
                return Forbid();

            if (IdClaseReserva <= 0 || IdClienteReserva <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Selecciona una clase y un socio para generar la reserva.";
                CargarDatos();
                return Page();
            }

            int idEmpleado = ObtenerIdEmpleado();
            int idUsuario = ObtenerIdUsuario();

            var r = _logicaReserva.Reservar(IdClaseReserva, IdClienteReserva, idEmpleado, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            // Mantener el filtro en la clase inscrita para ver al nuevo alumno
            FiltroClase = IdClaseReserva;
            CargarDatos();
            return Page();
        }

        public IActionResult OnPostAsistencia(int idReserva, byte resultado)
        {
            if (!PuedeTomarAsistencia)
                return Forbid();

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaReserva.RegistrarAsistencia(idReserva, resultado, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            CargarDatos();
            return Page();
        }

        public IActionResult OnPostCancelar(int idReserva)
        {
            if (!PuedeInscribir)
                return Forbid();

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaReserva.Cancelar(idReserva, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            CargarDatos();
            return Page();
        }

        private void CargarDatos()
        {
            int? idEmpleadoFiltro = null;
            if (EsEntrenador)
            {
                int empId = ObtenerIdEmpleado();
                if (empId > 0)
                {
                    idEmpleadoFiltro = empId;
                }
            }

            // Consultar clases programadas (estatus = 1) o todas según el rol
            Clases = _logicaClase.Consultar(null, null, null, idEmpleadoFiltro, null);
            Reservas = _logicaReserva.Consultar(FiltroClase, FiltroCliente, null, FiltroEstatus, idEmpleadoFiltro);
            Socios = _logicaCliente.ConsultarConSuscripcionVigente();
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }

        private int ObtenerIdEmpleado()
        {
            var idClaim = User.FindFirst("IdEmpleado")?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
