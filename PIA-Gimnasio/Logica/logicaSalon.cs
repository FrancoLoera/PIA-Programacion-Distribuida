using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaSalon
    {
        private readonly bdConexion _bd;

        public logicaSalon(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Guardar(bdSalon s, int idUsuario = 1)
        {
            int accion = s.IdSalon == 0 ? 1 : 4;

            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdSalon", s.IdSalon),
                new SqlParameter("@NombreNumero", Valor(s.NombreNumero?.Trim())),
                new SqlParameter("@IdSucursal", s.IdSucursal),
                new SqlParameter("@IdEstatus", s.IdEstatus),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SALON", p);
            return Respuesta(dt);
        }

        public bdSalon? Obtener(int id)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdSalon", id)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SALON", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return new bdSalon
            {
                IdSalon = Convert.ToInt32(r["IdSalon"]),
                NombreNumero = r["NombreNumero"].ToString() ?? "",
                IdSucursal = Convert.ToInt16(r["IdSucursal"]),
                Sucursal = r["Sucursal"]?.ToString(),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"]?.ToString()
            };
        }

        public DataTable Consultar(short? idSucursal = null, byte? idEstatus = null, string? nombreNumero = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value),
                new SqlParameter("@NombreNumero", Valor(nombreNumero))
            };

            return _bd.EjecutarStoredProcedure("dbo.SP_SALON", p);
        }

        public bdRespuesta DarDeBaja(int id, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdSalon", id),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SALON", p);
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
