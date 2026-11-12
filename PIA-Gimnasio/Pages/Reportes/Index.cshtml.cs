using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Reportes
{
    [Authorize(Roles = "Administrador,Recepcionista,Entrenador")]
    public class IndexModel : PageModel
    {
        private readonly logicaReporte _logicaReporte;
        private readonly logicaSucursal _logicaSucursal;
        private readonly logicaMembresia _logicaMembresia;
        private readonly logicaCliente _logicaCliente;
        private readonly logicaEmpleado _logicaEmpleado;
        private readonly logicaPuesto _logicaPuesto;
        private readonly logicaClase _logicaClase;
        private readonly logicaRutina _logicaRutina;

        public IndexModel(
            logicaReporte logicaReporte,
            logicaSucursal logicaSucursal,
            logicaMembresia logicaMembresia,
            logicaCliente logicaCliente,
            logicaEmpleado logicaEmpleado,
            logicaPuesto logicaPuesto,
            logicaClase logicaClase,
            logicaRutina logicaRutina)
        {
            _logicaReporte = logicaReporte;
            _logicaSucursal = logicaSucursal;
            _logicaMembresia = logicaMembresia;
            _logicaCliente = logicaCliente;
            _logicaEmpleado = logicaEmpleado;
            _logicaPuesto = logicaPuesto;
            _logicaClase = logicaClase;
            _logicaRutina = logicaRutina;
        }

        [BindProperty(SupportsGet = true)]
        public string TipoReporte { get; set; } = "Socios";

        // Filtros Compartidos
        [BindProperty(SupportsGet = true)]
        public short? FiltroSucursal { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroCliente { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroEmpleado { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FechaInicio { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FechaFin { get; set; }

        // Filtros Socios
        [BindProperty(SupportsGet = true)]
        public byte? FiltroMembresia { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatusCliente { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatusSuscripcion { get; set; }

        // Filtros Clases
        [BindProperty(SupportsGet = true)]
        public int? FiltroClase { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FiltroFechaClase { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatusReserva { get; set; }

        // Filtros Rutinas
        [BindProperty(SupportsGet = true)]
        public string? FiltroObjetivo { get; set; }

        [BindProperty(SupportsGet = true)]
        public short? FiltroGrupoMuscular { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroDificultad { get; set; }

        // Filtros Empleados
        [BindProperty(SupportsGet = true)]
        public byte? FiltroPuesto { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEspecialidad { get; set; }

        public DataTable DatosReporte { get; set; } = new DataTable();

        // Catálogos para filtros
        public DataTable Sucursales { get; set; } = new DataTable();
        public DataTable Membresias { get; set; } = new DataTable();
        public DataTable Socios { get; set; } = new DataTable();
        public DataTable Empleados { get; set; } = new DataTable();
        public DataTable Puestos { get; set; } = new DataTable();
        public DataTable Clases { get; set; } = new DataTable();
        public DataTable Especialidades { get; set; } = new DataTable();
        public List<bdGrupoMuscular> GruposMusculares { get; set; } = new List<bdGrupoMuscular>();
        public List<bdDificultad> Dificultades { get; set; } = new List<bdDificultad>();

        public void OnGet()
        {
            CargarCatalogos();
            EjecutarReporte();
        }

        private void CargarCatalogos()
        {
            Sucursales = _logicaSucursal.Consultar();
            Membresias = _logicaMembresia.ConsultarPlanes();
            Socios = _logicaCliente.Consultar();
            Empleados = _logicaEmpleado.Consultar();
            Puestos = _logicaPuesto.Consultar();
            Clases = _logicaClase.Consultar();
            Especialidades = _logicaClase.ConsultarEspecialidades();
            GruposMusculares = _logicaRutina.ConsultarGruposMusculares();
            Dificultades = _logicaRutina.ConsultarDificultades();
        }

        private void EjecutarReporte()
        {
            switch (TipoReporte?.ToLower())
            {
                case "acceso":
                    DatosReporte = _logicaReporte.ReporteControlAcceso(FiltroCliente, FiltroSucursal, FechaInicio, FechaFin);
                    break;
                case "clases":
                    DatosReporte = _logicaReporte.ReporteClases(FiltroSucursal, FiltroClase, FiltroEmpleado, FiltroFechaClase, FiltroEstatusReserva);
                    break;
                case "rutinas":
                    DatosReporte = _logicaReporte.ReporteRutinas(FiltroCliente, FiltroEmpleado, FiltroObjetivo, FiltroGrupoMuscular, FiltroDificultad, FechaInicio, FechaFin);
                    break;
                case "empleados":
                    DatosReporte = _logicaReporte.ReporteEmpleados(FiltroSucursal, FiltroPuesto, FiltroEspecialidad, FechaInicio, FechaFin);
                    break;
                case "socios":
                default:
                    TipoReporte = "Socios";
                    DatosReporte = _logicaReporte.ReporteSocios(FiltroSucursal, FiltroMembresia, FiltroEstatusCliente, FiltroEstatusSuscripcion);
                    break;
            }
        }
    }
}
