using System;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaControlAcceso
    {
        private readonly bdConexion _bd;

        public logicaControlAcceso(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta RegistrarEntrada(int idCliente, short idSucursal, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 1),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@IdSucursal", idSucursal),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CONTROL_ACCESO", p);
            return Respuesta(dt);
        }

        public bdRespuesta RegistrarSalida(int idCliente, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CONTROL_ACCESO", p);
            return Respuesta(dt);
        }

        public DataTable Consultar(int? idCliente = null, short? idSucursal = null, DateTime? fechaInicio = null, DateTime? fechaFin = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@FechaInicio", fechaInicio.HasValue ? (object)fechaInicio.Value : DBNull.Value),
                new SqlParameter("@FechaFin", fechaFin.HasValue ? (object)fechaFin.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_CONTROL_ACCESO", p);
        }

        public DataTable ConsultarEstadoActual(int idCliente)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 4),
                new SqlParameter("@IdCliente", idCliente)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_CONTROL_ACCESO", p);
        }

        private bdRespuesta Respuesta(DataTable dt)
        {
            if (dt.Rows.Count == 0)
                return new bdRespuesta { Mensaje = "Operación completada.", TipoMensaje = "success" };

            return new bdRespuesta
            {
                Mensaje = dt.Rows[0]["Mensaje"]?.ToString() ?? "",
                TipoMensaje = dt.Rows[0]["TipoMensaje"]?.ToString() ?? "info"
            };
        }
    }
}
