using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;

namespace PIA_Gimnasio.Logica
{
    public class logicaReporte
    {
        private readonly bdConexion _bd;

        public logicaReporte(bdConexion bd)
        {
            _bd = bd;
        }

        public DataTable ReporteSocios(short? idSucursal = null, byte? idMembresia = null, byte? idEstatusCliente = null, byte? idEstatusSuscripcion = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@IdMembresia", idMembresia.HasValue && idMembresia > 0 ? (object)idMembresia.Value : DBNull.Value),
                new SqlParameter("@IdEstatusCliente", idEstatusCliente.HasValue && idEstatusCliente > 0 ? (object)idEstatusCliente.Value : DBNull.Value),
                new SqlParameter("@IdEstatusSuscripcion", idEstatusSuscripcion.HasValue && idEstatusSuscripcion > 0 ? (object)idEstatusSuscripcion.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_REPORTE_SOCIOS", p);
        }

        public DataTable ReporteControlAcceso(int? idCliente = null, short? idSucursal = null, DateTime? fechaInicio = null, DateTime? fechaFin = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@FechaInicio", fechaInicio.HasValue ? (object)fechaInicio.Value : DBNull.Value),
                new SqlParameter("@FechaFin", fechaFin.HasValue ? (object)fechaFin.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_REPORTE_CONTROL_ACCESO", p);
        }

        public DataTable ReporteClases(short? idSucursal = null, int? idClase = null, int? idEmpleado = null, DateTime? fecha = null, byte? idEstatusReserva = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@IdClase", idClase.HasValue && idClase > 0 ? (object)idClase.Value : DBNull.Value),
                new SqlParameter("@IdEmpleado", idEmpleado.HasValue && idEmpleado > 0 ? (object)idEmpleado.Value : DBNull.Value),
                new SqlParameter("@Fecha", fecha.HasValue ? (object)fecha.Value.Date : DBNull.Value),
                new SqlParameter("@IdEstatusReserva", idEstatusReserva.HasValue && idEstatusReserva > 0 ? (object)idEstatusReserva.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_REPORTE_CLASES", p);
        }

        public DataTable ReporteRutinas(int? idCliente = null, int? idEmpleado = null, string? objetivo = null, short? idGrupoMuscular = null, byte? idDificultad = null, DateTime? fechaInicio = null, DateTime? fechaFin = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@IdEmpleado", idEmpleado.HasValue && idEmpleado > 0 ? (object)idEmpleado.Value : DBNull.Value),
                new SqlParameter("@Objetivo", !string.IsNullOrWhiteSpace(objetivo) ? (object)objetivo.Trim() : DBNull.Value),
                new SqlParameter("@IdGrupoMuscular", idGrupoMuscular.HasValue && idGrupoMuscular > 0 ? (object)idGrupoMuscular.Value : DBNull.Value),
                new SqlParameter("@IdDificultad", idDificultad.HasValue && idDificultad > 0 ? (object)idDificultad.Value : DBNull.Value),
                new SqlParameter("@FechaInicio", fechaInicio.HasValue ? (object)fechaInicio.Value.Date : DBNull.Value),
                new SqlParameter("@FechaFin", fechaFin.HasValue ? (object)fechaFin.Value.Date : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_REPORTE_RUTINAS", p);
        }

        public DataTable ReporteEmpleados(short? idSucursal = null, byte? idPuesto = null, byte? idEspecialidad = null, DateTime? fechaInicio = null, DateTime? fechaFin = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@IdPuesto", idPuesto.HasValue && idPuesto > 0 ? (object)idPuesto.Value : DBNull.Value),
                new SqlParameter("@IdEspecialidad", idEspecialidad.HasValue && idEspecialidad > 0 ? (object)idEspecialidad.Value : DBNull.Value),
                new SqlParameter("@FechaInicio", fechaInicio.HasValue ? (object)fechaInicio.Value.Date : DBNull.Value),
                new SqlParameter("@FechaFin", fechaFin.HasValue ? (object)fechaFin.Value.Date : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_REPORTE_EMPLEADOS", p);
        }
    }
}
