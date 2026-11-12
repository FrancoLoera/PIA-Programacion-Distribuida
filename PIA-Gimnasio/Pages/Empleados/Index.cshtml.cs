using System;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Empleados
{
    [Authorize(Roles = "Administrador")]
    public class IndexModel : PageModel
    {
        private readonly logicaEmpleado _logicaEmpleado;
        private readonly logicaSucursal _logicaSucursal;
        private readonly logicaPuesto _logicaPuesto;

        public IndexModel(logicaEmpleado logicaEmpleado, logicaSucursal logicaSucursal, logicaPuesto logicaPuesto)
        {
            _logicaEmpleado = logicaEmpleado;
            _logicaSucursal = logicaSucursal;
            _logicaPuesto = logicaPuesto;
        }

        [BindProperty]
        public bdEmpleado Empleado { get; set; } = new bdEmpleado();

        [BindProperty(SupportsGet = true)]
        public string? Buscar { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        [BindProperty(SupportsGet = true)]
        public short? IdSucursalFiltro { get; set; }

        public DataTable Empleados { get; set; } = new DataTable();
        public DataTable Sucursales { get; set; } = new DataTable();
        public DataTable Puestos { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            CargarDatos();
        }

        public void OnGetEditar(int id)
        {
            Empleado = _logicaEmpleado.Obtener(id) ?? new bdEmpleado();
            // Mantener el filtro selections after edit
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Verifica los datos obligatorios del empleado.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaEmpleado.Guardar(Empleado, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                // Preserve the current sucursal selection for a quick next insert
                short sucursalActual = Empleado.IdSucursal;
                ModelState.Clear();
                Empleado = new bdEmpleado { IdSucursal = sucursalActual };
            }
            CargarDatos();
        }

        public void OnPostBaja(int id)
        {
            int idUsuario = ObtenerIdUsuario();
            var r = _logicaEmpleado.DarDeBaja(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            CargarDatos();
        }

        private void CargarDatos()
        {
            // Listado de empleados con filtros opcionales
            Empleados = _logicaEmpleado.Consultar(Buscar, null, FiltroEstatus, IdSucursalFiltro);
            Sucursales = _logicaSucursal.Consultar();
            Puestos = _logicaPuesto.Consultar();
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
