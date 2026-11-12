using System;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaReserva
    {
        private readonly bdConexion _bd;

        public logicaReserva(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Reservar(int idClase, int idCliente, int idEmpleado, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)1),
                new SqlParameter("@IdClase", idClase),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@IdEmpleado", idEmpleado),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RESERVA", p);
            return Respuesta(dt);
        }

        public bdReserva? Obtener(int idReserva)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)2),
                new SqlParameter("@IdReserva", idReserva)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RESERVA", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return new bdReserva
            {
                IdReserva = Convert.ToInt32(r["IdReserva"]),
                FechaHora = Convert.ToDateTime(r["FechaHora"]),
                IdClase = Convert.ToInt32(r["IdClase"]),
                Clase = r["Clase"]?.ToString(),
                FechaClase = Convert.ToDateTime(r["Fecha"]),
                HoraInicio = (TimeSpan)r["HoraInicio"],
                HoraFin = (TimeSpan)r["HoraFin"],
                IdCliente = Convert.ToInt32(r["IdCliente"]),
                Folio = r["Folio"]?.ToString(),
                Cliente = r["Cliente"]?.ToString(),
                IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                Capturo = r["Capturo"]?.ToString(),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"]?.ToString()
            };
        }

        public DataTable Consultar(int? idClase = null, int? idCliente = null, int? idEmpleado = null, byte? idEstatus = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)3),
                new SqlParameter("@IdClase", idClase.HasValue && idClase > 0 ? (object)idClase.Value : DBNull.Value),
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@IdEmpleado", idEmpleado.HasValue && idEmpleado > 0 ? (object)idEmpleado.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_RESERVA", p);
        }

        public bdRespuesta Cancelar(int idReserva, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)5),
                new SqlParameter("@IdReserva", idReserva),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RESERVA", p);
            return Respuesta(dt);
        }

        public bdRespuesta RegistrarAsistencia(int idReserva, byte resultadoAsistencia, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)6),
                new SqlParameter("@IdReserva", idReserva),
                new SqlParameter("@ResultadoAsistencia", resultadoAsistencia), // 3=Asistió, 4=No asistió
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RESERVA", p);
            return Respuesta(dt);
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
