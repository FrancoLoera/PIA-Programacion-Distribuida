using System;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Clases
{
    [Authorize(Roles = "Administrador,Recepcionista,Entrenador")]
    public class IndexModel : PageModel
    {
        private readonly logicaClase _logicaClase;
        private readonly logicaSalon _logicaSalon;
        private readonly logicaEmpleado _logicaEmpleado;

        public IndexModel(logicaClase logicaClase, logicaSalon logicaSalon, logicaEmpleado logicaEmpleado)
        {
            _logicaClase = logicaClase;
            _logicaSalon = logicaSalon;
            _logicaEmpleado = logicaEmpleado;
        }

        [BindProperty]
        public bdClase Clase { get; set; } = new bdClase();

        [BindProperty(SupportsGet = true)]
        public string? Buscar { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FiltroFecha { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroSalon { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroEmpleado { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        public DataTable Clases { get; set; } = new DataTable();
        public DataTable Salones { get; set; } = new DataTable();
        public DataTable Instructores { get; set; } = new DataTable();
        public DataTable Especialidades { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public bool EsEntrenador => User.IsInRole("Entrenador");
        public bool PuedeGestionar => User.IsInRole("Administrador") || User.IsInRole("Recepcionista");

        public void OnGet()
        {
            // Si el usuario es entrenador y no especificó filtro, mostrar sus clases por defecto
            if (EsEntrenador && !FiltroEmpleado.HasValue)
            {
                var idEmpClaim = User.FindFirst("IdEmpleado")?.Value;
                if (int.TryParse(idEmpClaim, out int idEmp) && idEmp > 0)
                {
                    FiltroEmpleado = idEmp;
                }
            }

            CargarDatos();
        }

        public void OnGetEditar(int id)
        {
            if (!PuedeGestionar)
            {
                TipoMensaje = "warning";
                Mensaje = "No tienes permisos para modificar clases.";
                CargarDatos();
                return;
            }

            Clase = _logicaClase.Obtener(id) ?? new bdClase();
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            if (!PuedeGestionar)
            {
                TipoMensaje = "warning";
                Mensaje = "No tienes permisos para programar clases.";
                CargarDatos();
                return;
            }

            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos obligatorios de la clase.";
                CargarDatos();
                return;
            }

            if (Clase.HoraFin <= Clase.HoraInicio)
            {
                TipoMensaje = "warning";
                Mensaje = "La hora de fin debe ser posterior a la hora de inicio.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaClase.Guardar(Clase, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                var fechaActual = Clase.Fecha;
                ModelState.Clear();
                Clase = new bdClase { Fecha = fechaActual };
            }
            CargarDatos();
        }

        public void OnPostCancelar(int id)
        {
            if (!PuedeGestionar)
            {
                TipoMensaje = "warning";
                Mensaje = "No tienes permisos para cancelar clases.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaClase.Cancelar(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            CargarDatos();
        }

        private void CargarDatos()
        {
            Clases = _logicaClase.Consultar(Buscar, FiltroFecha, FiltroSalon, FiltroEmpleado, FiltroEstatus);
            Salones = _logicaSalon.Consultar(null, 1); // Salones activos
            Instructores = _logicaEmpleado.Consultar(null, null, 1); // Empleados activos
            Especialidades = _logicaClase.ConsultarEspecialidades();
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
