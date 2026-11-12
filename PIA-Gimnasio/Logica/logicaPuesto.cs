using System;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaPuesto
    {
        private readonly bdConexion _bd;

        public logicaPuesto(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Guardar(bdPuesto p, int idUsuario = 1)
        {
            int accion = p.IdPuesto == 0 ? 1 : 4; // 1 Insert, 4 Update
            SqlParameter[] param = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdPuesto", p.IdPuesto > 0 ? (object)p.IdPuesto : DBNull.Value),
                new SqlParameter("@Nombre", Valor(p.Nombre)),
                new SqlParameter("@Descripcion", Valor(p.Descripcion)),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_PUESTO", param);
            return Respuesta(dt);
        }

        public bdPuesto? Obtener(byte id)
        {
            SqlParameter[] param = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdPuesto", id)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_PUESTO", param);
            if (dt.Rows.Count == 0) return null;
            DataRow r = dt.Rows[0];
            return new bdPuesto
            {
                IdPuesto = Convert.ToByte(r["IdPuesto"]),
                Nombre = r["Nombre"]?.ToString() ?? "",
                Descripcion = r["Descripcion"]?.ToString() ?? ""
            };
        }

        public DataTable Consultar()
        {
            SqlParameter[] param = {
                new SqlParameter("@Accion", 3)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_PUESTO", param);
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

        private object Valor(string? texto) => string.IsNullOrWhiteSpace(texto) ? DBNull.Value : (object)texto.Trim();
    }
}
