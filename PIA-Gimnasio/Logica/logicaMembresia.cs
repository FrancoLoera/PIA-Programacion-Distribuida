using System;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaMembresia
    {
        private readonly bdConexion _bd;

        public logicaMembresia(bdConexion bd)
        {
            _bd = bd;
        }

        // ════════════════════════════════════════════════════════════════════
        // CATÁLOGO DE PLANES DE MEMBRESÍA (dbo.SP_MEMBRESIA)
        // ════════════════════════════════════════════════════════════════════

        public DataTable ConsultarPlanes()
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_MEMBRESIA", p);
        }

        public bdMembresia? ObtenerPlan(byte id)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdMembresia", id)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_MEMBRESIA", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return new bdMembresia
            {
                IdMembresia = Convert.ToByte(r["IdMembresia"]),
                Nombre = r["Nombre"]?.ToString() ?? "",
                Precio = Convert.ToDecimal(r["Precio"]),
                Descripcion = r["Descripcion"]?.ToString() ?? "",
                PermiteClases = Convert.ToBoolean(r["PermiteClases"]),
                MaxClasesSemana = Convert.ToByte(r["MaxClasesSemana"]),
                SujetaAforo = Convert.ToBoolean(r["SujetaAforo"])
            };
        }

        public bdRespuesta GuardarPlan(bdMembresia plan, int idUsuario = 1)
        {
            int accion = plan.IdMembresia == 0 ? 1 : 4;
            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdMembresia", plan.IdMembresia > 0 ? (object)plan.IdMembresia : DBNull.Value),
                new SqlParameter("@Nombre", Valor(plan.Nombre?.Trim())),
                new SqlParameter("@Precio", plan.Precio),
                new SqlParameter("@Descripcion", Valor(plan.Descripcion?.Trim())),
                new SqlParameter("@PermiteClases", plan.PermiteClases),
                new SqlParameter("@MaxClasesSemana", plan.PermiteClases ? plan.MaxClasesSemana : (byte)0),
                new SqlParameter("@SujetaAforo", plan.SujetaAforo),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_MEMBRESIA", p);
            return Respuesta(dt);
        }

        // ════════════════════════════════════════════════════════════════════
        // SUSCRIPCIONES DE SOCIOS (dbo.SP_SUSCRIPCION)
        // ════════════════════════════════════════════════════════════════════

        public DataTable ConsultarSuscripciones(int? idCliente = null, byte? idMembresia = null, byte? idEstatus = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@IdMembresia", idMembresia.HasValue && idMembresia > 0 ? (object)idMembresia.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_SUSCRIPCION", p);
        }

        public bdSuscripcion? ObtenerSuscripcion(int id)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdSuscripcion", id)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUSCRIPCION", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return new bdSuscripcion
            {
                IdSuscripcion = Convert.ToInt32(r["IdSuscripcion"]),
                FechaInicio = Convert.ToDateTime(r["FechaInicio"]),
                FechaVencimiento = r["FechaVencimiento"] == DBNull.Value ? null : Convert.ToDateTime(r["FechaVencimiento"]),
                IdCliente = Convert.ToInt32(r["IdCliente"]),
                Folio = r["Folio"]?.ToString(),
                SocioNombre = $"{r["PrimerApellido"]} {r["Nombres"]}",
                IdMembresia = Convert.ToByte(r["IdMembresia"]),
                Membresia = r["Membresia"]?.ToString(),
                Precio = r["Precio"] == DBNull.Value ? null : Convert.ToDecimal(r["Precio"]),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"]?.ToString(),
                EstadoVigencia = r["EstadoVigencia"]?.ToString()
            };
        }

        public bdRespuesta GuardarSuscripcion(bdSuscripcion s, int idUsuario = 1)
        {
            int accion = s.IdSuscripcion == 0 ? 1 : 4;
            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdSuscripcion", s.IdSuscripcion > 0 ? (object)s.IdSuscripcion : DBNull.Value),
                new SqlParameter("@FechaInicio", s.FechaInicio.Date),
                new SqlParameter("@IdCliente", s.IdCliente),
                new SqlParameter("@IdMembresia", s.IdMembresia),
                new SqlParameter("@IdEstatus", s.IdEstatus),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUSCRIPCION", p);
            return Respuesta(dt);
        }

        public bdRespuesta CancelarSuscripcion(int id, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdSuscripcion", id),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUSCRIPCION", p);
            return Respuesta(dt);
        }

        // ════════════════════════════════════════════════════════════════════
        // HELPERS
        // ════════════════════════════════════════════════════════════════════

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
