using System;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaSucursal
    {
        private readonly bdConexion _bd;

        public logicaSucursal(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Guardar(bdSucursal s, int idUsuario = 1)
        {
            int accion = s.IdSucursal == 0 ? 1 : 4;

            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdSucursal", s.IdSucursal),
                new SqlParameter("@Nombre", Valor(s.Nombre?.Trim())),
                new SqlParameter("@Telefono", Valor(s.Telefono?.Trim())),
                new SqlParameter("@NumeroExterior", Valor(s.NumeroExterior?.Trim())),
                new SqlParameter("@NumeroInterior", Valor(s.NumeroInterior?.Trim())),
                new SqlParameter("@Calle", Valor(s.Calle?.Trim())),
                new SqlParameter("@Colonia", Valor(s.Colonia?.Trim())),
                new SqlParameter("@Ciudad", Valor(s.Ciudad?.Trim())),
                new SqlParameter("@Estado", Valor(s.Estado?.Trim())),
                new SqlParameter("@AforoMaximo", s.AforoMaximo),
                new SqlParameter("@HoraApertura", s.HoraApertura),
                new SqlParameter("@HoraCierre", s.HoraCierre),
                new SqlParameter("@IdEstatus", s.IdEstatus),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUCURSAL", p);
            return Respuesta(dt);
        }

        public bdSucursal? Obtener(short id)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdSucursal", id)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUCURSAL", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return new bdSucursal
            {
                IdSucursal = Convert.ToInt16(r["IdSucursal"]),
                Nombre = r["Nombre"].ToString() ?? "",
                Telefono = r["Telefono"].ToString() ?? "",
                NumeroExterior = r["NumeroExterior"].ToString() ?? "",
                NumeroInterior = r["NumeroInterior"] == DBNull.Value ? null : r["NumeroInterior"].ToString(),
                Calle = r["Calle"].ToString() ?? "",
                Colonia = r["Colonia"].ToString() ?? "",
                Ciudad = r["Ciudad"].ToString() ?? "",
                Estado = r["Estado"].ToString() ?? "",
                AforoMaximo = Convert.ToInt16(r["AforoMaximo"]),
                HoraApertura = (TimeSpan)r["HoraApertura"],
                HoraCierre = (TimeSpan)r["HoraCierre"],
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"]?.ToString()
            };
        }

        public DataTable Consultar(string? nombre = null, string? ciudad = null, string? estado = null, byte? idEstatus = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@Nombre", Valor(nombre)),
                new SqlParameter("@Ciudad", Valor(ciudad)),
                new SqlParameter("@Estado", Valor(estado)),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value)
            };

            return _bd.EjecutarStoredProcedure("dbo.SP_SUCURSAL", p);
        }

        public bdRespuesta DarDeBaja(short id, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdSucursal", id),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUCURSAL", p);
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

        private object Valor(string? texto)
        {
            return string.IsNullOrWhiteSpace(texto) ? DBNull.Value : texto.Trim();
        }
    }
}
