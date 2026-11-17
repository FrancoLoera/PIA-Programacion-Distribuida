using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaEjercicio
    {
        private readonly bdConexion _bd;

        public logicaEjercicio(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Guardar(bdEjercicio ejercicio, int idUsuario = 1)
        {
            int accion = ejercicio.IdEjercicio == 0 ? 1 : 4;
            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdEjercicio", ejercicio.IdEjercicio),
                new SqlParameter("@Nombre", Valor(ejercicio.Nombre)),
                new SqlParameter("@Descripcion", Valor(ejercicio.Descripcion)),
                new SqlParameter("@IdGrupoMuscular", ejercicio.IdGrupoMuscular),
                new SqlParameter("@IdDificultad", ejercicio.IdDificultad),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            return Respuesta(_bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p));
        }

        public bdEjercicio? Obtener(int idEjercicio)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdEjercicio", idEjercicio)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p);
            if (dt.Rows.Count == 0)
                return null;

            DataRow r = dt.Rows[0];
            return new bdEjercicio
            {
                IdEjercicio = Convert.ToInt32(r["IdEjercicio"]),
                Nombre = r["Nombre"]?.ToString() ?? "",
                Descripcion = r["Descripcion"]?.ToString(),
                IdGrupoMuscular = Convert.ToInt16(r["IdGrupoMuscular"]),
                GrupoMuscular = r["GrupoMuscular"]?.ToString(),
                IdDificultad = Convert.ToByte(r["IdDificultad"]),
                Dificultad = r["Dificultad"]?.ToString()
            };
        }

        public bdRespuesta Eliminar(int idEjercicio, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdEjercicio", idEjercicio),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            return Respuesta(_bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p));
        }

        public bdRespuesta AgregarContraindicacion(int idEjercicio, byte idCondicion, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 6),
                new SqlParameter("@IdEjercicio", idEjercicio),
                new SqlParameter("@IdCondicion", idCondicion),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            return Respuesta(_bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p));
        }

        public List<bdCondicion> ListarContraindicaciones(int idEjercicio)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 7),
                new SqlParameter("@IdEjercicio", idEjercicio)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p);
            var lista = new List<bdCondicion>();
            foreach (DataRow r in dt.Rows)
            {
                lista.Add(new bdCondicion
                {
                    IdCondicion = Convert.ToByte(r["IdCondicion"]),
                    Nombre = r["Condicion"]?.ToString() ?? "",
                    Tipo = r["Tipo"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString()
                });
            }
            return lista;
        }

        public bdRespuesta QuitarContraindicacion(int idEjercicio, byte idCondicion, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 8),
                new SqlParameter("@IdEjercicio", idEjercicio),
                new SqlParameter("@IdCondicion", idCondicion),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            return Respuesta(_bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p));
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
