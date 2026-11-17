using System.Collections.Generic;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Ejercicios
{
    [Authorize(Roles = "Administrador,Entrenador")]
    public class IndexModel : PageModel
    {
        private readonly logicaEjercicio _logicaEjercicio;
        private readonly logicaRutina _logicaRutina;
        private readonly logicaExpediente _logicaExpediente;

        public IndexModel(logicaEjercicio logicaEjercicio, logicaRutina logicaRutina, logicaExpediente logicaExpediente)
        {
            _logicaEjercicio = logicaEjercicio;
            _logicaRutina = logicaRutina;
            _logicaExpediente = logicaExpediente;
        }

        [BindProperty]
        public bdEjercicio Ejercicio { get; set; } = new bdEjercicio();

        [BindProperty(SupportsGet = true)]
        public string? Buscar { get; set; }

        [BindProperty(SupportsGet = true)]
        public short? FiltroGrupo { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroDificultad { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? EjercicioDetalle { get; set; }

        [BindProperty]
        public byte IdCondicionContraindicacion { get; set; }

        public List<bdEjercicio> Ejercicios { get; set; } = new List<bdEjercicio>();
        public List<bdGrupoMuscular> Grupos { get; set; } = new List<bdGrupoMuscular>();
        public List<bdDificultad> Dificultades { get; set; } = new List<bdDificultad>();
        public List<bdCondicion> CatalogoCondiciones { get; set; } = new List<bdCondicion>();
        public bdEjercicio? EjercicioActual { get; set; }
        public List<bdCondicion> ContraindicacionesActuales { get; set; } = new List<bdCondicion>();
        public List<bdCondicion> CondicionesDisponibles => CatalogoCondiciones.FindAll(c => !ContraindicacionesActuales.Exists(a => a.IdCondicion == c.IdCondicion));

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public bool PuedeEditar => User.IsInRole("Administrador");

        public void OnGet()
        {
            CargarDatos();
        }

        public IActionResult OnGetEditar(int id)
        {
            if (!PuedeEditar)
                return Forbid();

            Ejercicio = _logicaEjercicio.Obtener(id) ?? new bdEjercicio();
            CargarDatos();
            return Page();
        }

        public IActionResult OnPostGuardar()
        {
            if (!PuedeEditar)
                return Forbid();

            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos obligatorios del ejercicio.";
                CargarDatos();
                return Page();
            }

            var r = _logicaEjercicio.Guardar(Ejercicio, ObtenerIdUsuario());
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            if (r.TipoMensaje == "success")
            {
                ModelState.Clear();
                Ejercicio = new bdEjercicio();
            }
            CargarDatos();
            return Page();
        }

        public IActionResult OnPostEliminar(int id)
        {
            if (!PuedeEditar)
                return Forbid();

            var r = _logicaEjercicio.Eliminar(id, ObtenerIdUsuario());
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            EjercicioDetalle = null;
            CargarDatos();
            return Page();
        }

        public IActionResult OnPostAgregarContraindicacion()
        {
            if (!PuedeEditar)
                return Forbid();

            if (EjercicioDetalle.HasValue && IdCondicionContraindicacion > 0)
            {
                var r = _logicaEjercicio.AgregarContraindicacion(EjercicioDetalle.Value, IdCondicionContraindicacion, ObtenerIdUsuario());
                Mensaje = r.Mensaje;
                TipoMensaje = r.TipoMensaje;
            }
            else
            {
                TipoMensaje = "warning";
                Mensaje = "Selecciona la condición médica contraindicada.";
            }
            CargarDatos();
            return Page();
        }

        public IActionResult OnPostQuitarContraindicacion(byte idCondicion)
        {
            if (!PuedeEditar)
                return Forbid();

            if (EjercicioDetalle.HasValue)
            {
                var r = _logicaEjercicio.QuitarContraindicacion(EjercicioDetalle.Value, idCondicion, ObtenerIdUsuario());
                Mensaje = r.Mensaje;
                TipoMensaje = r.TipoMensaje;
            }
            CargarDatos();
            return Page();
        }

        private void CargarDatos()
        {
            Ejercicios = _logicaRutina.ConsultarEjercicios(Buscar, FiltroGrupo, FiltroDificultad);
            Grupos = _logicaRutina.ConsultarGruposMusculares();
            Dificultades = _logicaRutina.ConsultarDificultades();
            CatalogoCondiciones = _logicaExpediente.CatalogoCondiciones();

            if (EjercicioDetalle.HasValue && EjercicioDetalle > 0)
            {
                EjercicioActual = _logicaEjercicio.Obtener(EjercicioDetalle.Value);
                if (EjercicioActual != null)
                    ContraindicacionesActuales = _logicaEjercicio.ListarContraindicaciones(EjercicioDetalle.Value);
            }
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
