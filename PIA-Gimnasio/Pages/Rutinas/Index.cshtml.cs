using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Rutinas
{
    [Authorize(Roles = "Administrador,Recepcionista,Entrenador")]
    public class IndexModel : PageModel
    {
        private readonly logicaRutina _logicaRutina;
        private readonly logicaCliente _logicaCliente;
        private readonly logicaEmpleado _logicaEmpleado;

        public IndexModel(logicaRutina logicaRutina, logicaCliente logicaCliente, logicaEmpleado logicaEmpleado)
        {
            _logicaRutina = logicaRutina;
            _logicaCliente = logicaCliente;
            _logicaEmpleado = logicaEmpleado;
        }

        [BindProperty(SupportsGet = true)]
        public int? FiltroCliente { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroEmpleado { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? FiltroNombre { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? RutinaDetalle { get; set; }

        [BindProperty(SupportsGet = true)]
        public bool VerAlertas { get; set; }

        public List<bdRutina> Rutinas { get; set; } = new List<bdRutina>();
        public List<bdRutinaAlerta> AlertasMedicas { get; set; } = new List<bdRutinaAlerta>();
        public bdRutina? RutinaActual { get; set; }
        public List<bdDetalleRutina> DetallesActuales { get; set; } = new List<bdDetalleRutina>();
        public List<bdEjercicio> CatalogoEjercicios { get; set; } = new List<bdEjercicio>();
        public DataTable Socios { get; set; } = new DataTable();
        public DataTable Empleados { get; set; } = new DataTable();

        // Form Crear Rutina
        [BindProperty]
        public string NombreRutina { get; set; } = "";

        [BindProperty]
        public string ObjetivoRutina { get; set; } = "";

        [BindProperty]
        public int IdClienteRutina { get; set; }

        [BindProperty]
        public int IdEmpleadoRutina { get; set; }

        [BindProperty]
        public DateTime? FechaAsignacionRutina { get; set; } = DateTime.Today;

        // Form Modificar Rutina
        [BindProperty]
        public int IdRutinaModificar { get; set; }

        [BindProperty]
        public string NombreRutinaModificar { get; set; } = "";

        [BindProperty]
        public string ObjetivoRutinaModificar { get; set; } = "";

        // Form Estatus
        [BindProperty]
        public int IdRutinaEstatus { get; set; }

        [BindProperty]
        public byte NuevoEstatus { get; set; }

        // Form Agregar Ejercicio
        [BindProperty]
        public int IdRutinaEjercicio { get; set; }

        [BindProperty]
        public int IdEjercicio { get; set; }

        [BindProperty]
        public byte DiaSemana { get; set; } = 1;

        [BindProperty]
        public byte Series { get; set; } = 4;

        [BindProperty]
        public string Repeticiones { get; set; } = "12";

        [BindProperty]
        public short TiempoDescanso { get; set; } = 60;

        [BindProperty]
        public bool IgnorarContraindicacion { get; set; } = false;

        // Form Quitar Ejercicio
        [BindProperty]
        public int IdRutinaQuitar { get; set; }

        [BindProperty]
        public int IdDetalleQuitar { get; set; }

        [TempData]
        public string Mensaje { get; set; } = "";

        [TempData]
        public string TipoMensaje { get; set; } = "";

        public bool PuedeEditar => User.IsInRole("Administrador") || User.IsInRole("Entrenador");
        public bool EsEntrenador => User.IsInRole("Entrenador");

        public void OnGet()
        {
            CargarDatos();
        }

        public IActionResult OnPostCrear()
        {
            if (string.IsNullOrWhiteSpace(NombreRutina) || string.IsNullOrWhiteSpace(ObjetivoRutina)
                || IdClienteRutina <= 0 || IdEmpleadoRutina <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Completa todos los campos obligatorios de la rutina.";
                return RedirectToPage(new { FiltroCliente, FiltroEmpleado, FiltroEstatus });
            }

            var resp = _logicaRutina.Crear(NombreRutina, ObjetivoRutina, IdClienteRutina, IdEmpleadoRutina, FechaAsignacionRutina, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { FiltroCliente = IdClienteRutina });
        }

        public IActionResult OnPostModificar()
        {
            if (IdRutinaModificar <= 0 || string.IsNullOrWhiteSpace(NombreRutinaModificar) || string.IsNullOrWhiteSpace(ObjetivoRutinaModificar))
            {
                TipoMensaje = "warning";
                Mensaje = "Datos de rutina incompletos.";
                return RedirectToPage(new { RutinaDetalle = IdRutinaModificar });
            }

            var resp = _logicaRutina.Modificar(IdRutinaModificar, NombreRutinaModificar, ObjetivoRutinaModificar, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { RutinaDetalle = IdRutinaModificar });
        }

        public IActionResult OnPostCambiarEstatus()
        {
            if (IdRutinaEstatus <= 0 || NuevoEstatus <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Parámetros de estatus inválidos.";
                return RedirectToPage(new { RutinaDetalle = IdRutinaEstatus });
            }

            var resp = _logicaRutina.CambiarEstatus(IdRutinaEstatus, NuevoEstatus, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { RutinaDetalle = IdRutinaEstatus });
        }

        public IActionResult OnPostAgregarEjercicio()
        {
            if (IdRutinaEjercicio <= 0 || IdEjercicio <= 0 || DiaSemana < 1 || DiaSemana > 7 || Series <= 0 || string.IsNullOrWhiteSpace(Repeticiones))
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos del ejercicio a agregar a la rutina.";
                return RedirectToPage(new { RutinaDetalle = IdRutinaEjercicio });
            }

            var resp = _logicaRutina.AgregarEjercicio(
                IdRutinaEjercicio,
                IdEjercicio,
                DiaSemana,
                Series,
                Repeticiones,
                TiempoDescanso,
                IgnorarContraindicacion,
                ObtenerIdUsuario()
            );

            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { RutinaDetalle = IdRutinaEjercicio });
        }

        public IActionResult OnPostQuitarEjercicio()
        {
            if (IdDetalleQuitar <= 0 || IdRutinaQuitar <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Datos del ejercicio a retirar incompletos.";
                return RedirectToPage();
            }

            var resp = _logicaRutina.QuitarEjercicio(IdDetalleQuitar, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { RutinaDetalle = IdRutinaQuitar });
        }

        private void CargarDatos()
        {
            int? idEmpleadoFiltro = FiltroEmpleado;
            if (EsEntrenador && !idEmpleadoFiltro.HasValue)
            {
                // Si es entrenador y no eligió filtro, podemos sugerir su id
                var empId = ObtenerIdEmpleado();
                if (empId > 0 && IdEmpleadoRutina == 0)
                {
                    IdEmpleadoRutina = empId;
                }
            }

            Rutinas = _logicaRutina.Consultar(FiltroCliente, idEmpleadoFiltro, FiltroEstatus, FiltroNombre);
            AlertasMedicas = _logicaRutina.ConsultarAlertas();
            CatalogoEjercicios = _logicaRutina.ConsultarEjercicios();
            Socios = _logicaCliente.Consultar(null, null, 1);
            Empleados = _logicaEmpleado.Consultar(null, null, 1);

            if (RutinaDetalle.HasValue && RutinaDetalle > 0)
            {
                RutinaActual = _logicaRutina.ObtenerPorId(RutinaDetalle.Value);
                if (RutinaActual != null)
                {
                    DetallesActuales = _logicaRutina.ListarDetalles(RutinaDetalle.Value);
                    NombreRutinaModificar = RutinaActual.Nombre;
                    ObjetivoRutinaModificar = RutinaActual.Objetivo;
                }
            }
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }

        private int ObtenerIdEmpleado()
        {
            var idClaim = User.FindFirst("IdEmpleado")?.Value;
            return int.TryParse(idClaim, out int id) ? id : 0;
        }
    }
}
