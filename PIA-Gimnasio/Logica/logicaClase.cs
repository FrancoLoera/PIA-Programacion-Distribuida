using System;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaClase
    {
        private readonly bdConexion _bd;

        public logicaClase(bdConexion bd)
        {
            _bd = bd;
        }

        public DataTable Consultar(string? nombre = null, DateTime? fecha = null, int? idSalon = null, int? idEmpleado = null, byte? idEstatus = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@Nombre", Valor(nombre)),
                new SqlParameter("@Fecha", fecha.HasValue ? (object)fecha.Value.Date : DBNull.Value),
                new SqlParameter("@IdSalon", idSalon.HasValue && idSalon > 0 ? (object)idSalon.Value : DBNull.Value),
                new SqlParameter("@IdEmpleado", idEmpleado.HasValue && idEmpleado > 0 ? (object)idEmpleado.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_CLASE", p);
        }

        public bdClase? Obtener(int idClase)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdClase", idClase)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLASE", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return new bdClase
            {
                IdClase = Convert.ToInt32(r["IdClase"]),
                Nombre = r["Nombre"]?.ToString() ?? "",
                Fecha = Convert.ToDateTime(r["Fecha"]),
                HoraInicio = (TimeSpan)r["HoraInicio"],
                HoraFin = (TimeSpan)r["HoraFin"],
                CupoMaximo = Convert.ToInt16(r["CupoMaximo"]),
                IdSalon = Convert.ToInt32(r["IdSalon"]),
                IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                IdEspecialidad = r["IdEspecialidad"] == DBNull.Value ? null : Convert.ToByte(r["IdEspecialidad"]),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Salon = r["Salon"]?.ToString(),
                IdSucursal = r["IdSucursal"] == DBNull.Value ? null : Convert.ToInt16(r["IdSucursal"]),
                Sucursal = r["Sucursal"]?.ToString(),
                Empleado = r["Empleado"]?.ToString(),
                EspecialidadRequerida = r["EspecialidadRequerida"]?.ToString(),
                Estatus = r["Estatus"]?.ToString()
            };
        }

        public bdRespuesta Guardar(bdClase clase, int idUsuario = 1)
        {
            int accion = clase.IdClase == 0 ? 1 : 4;
            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdClase", clase.IdClase > 0 ? (object)clase.IdClase : DBNull.Value),
                new SqlParameter("@Nombre", Valor(clase.Nombre?.Trim())),
                new SqlParameter("@Fecha", clase.Fecha.Date),
                new SqlParameter("@HoraInicio", clase.HoraInicio),
                new SqlParameter("@HoraFin", clase.HoraFin),
                new SqlParameter("@CupoMaximo", clase.CupoMaximo),
                new SqlParameter("@IdSalon", clase.IdSalon),
                new SqlParameter("@IdEmpleado", clase.IdEmpleado),
                new SqlParameter("@IdEspecialidad", clase.IdEspecialidad.HasValue && clase.IdEspecialidad > 0 ? (object)clase.IdEspecialidad.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", clase.IdEstatus),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLASE", p);
            return Respuesta(dt);
        }

        public bdRespuesta Cancelar(int idClase, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdClase", idClase),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLASE", p);
            return Respuesta(dt);
        }

        public DataTable ConsultarEspecialidades()
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_ESPECIALIDAD", p);
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

        private object Valor(string? texto)
            => string.IsNullOrWhiteSpace(texto) ? DBNull.Value : (object)texto.Trim();
    }
}
