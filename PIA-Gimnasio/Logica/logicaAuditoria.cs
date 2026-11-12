using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaAuditoria
    {
        private readonly bdConexion _bd;

        public logicaAuditoria(bdConexion bd)
        {
            _bd = bd;
        }

        public List<bdAuditoria> Consultar(
            string? nombreTabla = null,
            int? idRegistro = null,
            int? idUsuario = null,
            string? tipoOperacion = null,
            DateTime? fechaInicio = null,
            DateTime? fechaFin = null)
        {
            List<SqlParameter> p = new List<SqlParameter>
            {
                new SqlParameter("@NombreTabla", !string.IsNullOrWhiteSpace(nombreTabla) ? (object)nombreTabla.Trim() : DBNull.Value),
                new SqlParameter("@IdRegistro", idRegistro.HasValue && idRegistro > 0 ? (object)idRegistro.Value : DBNull.Value),
                new SqlParameter("@IdUsuario", idUsuario.HasValue && idUsuario > 0 ? (object)idUsuario.Value : DBNull.Value),
                new SqlParameter("@TipoOperacion", !string.IsNullOrWhiteSpace(tipoOperacion) ? (object)tipoOperacion.Trim() : DBNull.Value),
                new SqlParameter("@FechaInicio", fechaInicio.HasValue ? (object)fechaInicio.Value : DBNull.Value),
                new SqlParameter("@FechaFin", fechaFin.HasValue ? (object)fechaFin.Value : DBNull.Value)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_AUDITORIA", p.ToArray());
            var list = new List<bdAuditoria>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdAuditoria
                {
                    IdAuditoria = Convert.ToInt64(r["IdAuditoria"]),
                    NombreTabla = r["NombreTabla"]?.ToString() ?? "",
                    IdRegistro = Convert.ToInt32(r["IdRegistro"]),
                    TipoOperacion = r["TipoOperacion"]?.ToString() ?? "",
                    FechaOperacion = Convert.ToDateTime(r["FechaOperacion"]),
                    ValoresAnteriores = r["ValoresAnteriores"] == DBNull.Value ? null : r["ValoresAnteriores"]?.ToString(),
                    ValoresNuevos = r["ValoresNuevos"] == DBNull.Value ? null : r["ValoresNuevos"]?.ToString(),
                    IdUsuario = r["IdUsuario"] == DBNull.Value ? null : Convert.ToInt32(r["IdUsuario"]),
                    NombreCuenta = r["NombreCuenta"]?.ToString(),
                    RolUsuario = r["RolUsuario"]?.ToString(),
                    Operador = r["Operador"]?.ToString()
                });
            }
            return list;
        }

        public List<string> ConsultarTablasAuditadas()
        {
            DataTable dt = _bd.EjecutarConsulta("SELECT DISTINCT NombreTabla FROM dbo.AUDITORIA ORDER BY NombreTabla;");
            var list = new List<string>();
            foreach (DataRow r in dt.Rows)
            {
                var tabla = r["NombreTabla"]?.ToString();
                if (!string.IsNullOrWhiteSpace(tabla))
                {
                    list.Add(tabla);
                }
            }
            return list;
        }
    }
}
