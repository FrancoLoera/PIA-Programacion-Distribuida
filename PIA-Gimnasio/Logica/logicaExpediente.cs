using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaExpediente
    {
        private readonly bdConexion _bd;

        public logicaExpediente(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Registrar(int idCliente, string tipoSangre, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 1),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@TipoSangre", tipoSangre.Trim()),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            return Respuesta(dt);
        }

        public bdExpediente? ObtenerPorId(int idExpediente)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdExpediente", idExpediente)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return MapearExpediente(r);
        }

        public List<bdExpediente> Consultar(int? idCliente = null, string? tipoSangre = null)
        {
            List<SqlParameter> listaP = new List<SqlParameter>
            {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@TipoSangre", !string.IsNullOrWhiteSpace(tipoSangre) ? (object)tipoSangre.Trim() : DBNull.Value)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", listaP.ToArray());
            var list = new List<bdExpediente>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(MapearExpediente(r));
            }
            return list;
        }

        public bdRespuesta ModificarTipoSangre(int idExpediente, string tipoSangre, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 4),
                new SqlParameter("@IdExpediente", idExpediente),
                new SqlParameter("@TipoSangre", tipoSangre.Trim()),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            return Respuesta(dt);
        }

        public bdRespuesta AsociarCondicion(int idExpediente, byte idCondicion, string? observaciones, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 6),
                new SqlParameter("@IdExpediente", idExpediente),
                new SqlParameter("@IdCondicion", idCondicion),
                new SqlParameter("@Observaciones", !string.IsNullOrWhiteSpace(observaciones) ? (object)observaciones.Trim() : DBNull.Value),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            return Respuesta(dt);
        }

        public List<bdExpedienteCondicion> ObtenerCondiciones(int idExpediente)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 8),
                new SqlParameter("@IdExpediente", idExpediente)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            var list = new List<bdExpedienteCondicion>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdExpedienteCondicion
                {
                    IdExpediente = Convert.ToInt32(r["IdExpediente"]),
                    IdCondicion = Convert.ToByte(r["IdCondicion"]),
                    Nombre = r["Nombre"]?.ToString() ?? "",
                    Tipo = r["Tipo"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString(),
                    Observaciones = r["Observaciones"]?.ToString()
                });
            }
            return list;
        }

        public bdRespuesta ModificarObservacionesCondicion(int idExpediente, byte idCondicion, string? observaciones, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 9),
                new SqlParameter("@IdExpediente", idExpediente),
                new SqlParameter("@IdCondicion", idCondicion),
                new SqlParameter("@Observaciones", !string.IsNullOrWhiteSpace(observaciones) ? (object)observaciones.Trim() : DBNull.Value),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            return Respuesta(dt);
        }

        public bdRespuesta DesvincularCondicion(int idExpediente, byte idCondicion, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 10),
                new SqlParameter("@IdExpediente", idExpediente),
                new SqlParameter("@IdCondicion", idCondicion),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EXPEDIENTE", p);
            return Respuesta(dt);
        }

        // Catálogo de Condiciones (SP_CONDICION)
        public List<bdCondicion> CatalogoCondiciones(string? tipo = null, string? nombre = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@Nombre", !string.IsNullOrWhiteSpace(nombre) ? (object)nombre.Trim() : DBNull.Value),
                new SqlParameter("@Tipo", !string.IsNullOrWhiteSpace(tipo) ? (object)tipo.Trim() : DBNull.Value)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CONDICION", p);
            var list = new List<bdCondicion>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdCondicion
                {
                    IdCondicion = Convert.ToByte(r["IdCondicion"]),
                    Nombre = r["Nombre"]?.ToString() ?? "",
                    Tipo = r["Tipo"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString()
                });
            }
            return list;
        }

        public bdRespuesta RegistrarCondicionCatalogo(string nombre, string tipo, string? descripcion, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 1),
                new SqlParameter("@Nombre", nombre.Trim()),
                new SqlParameter("@Tipo", tipo.Trim()),
                new SqlParameter("@Descripcion", !string.IsNullOrWhiteSpace(descripcion) ? (object)descripcion.Trim() : DBNull.Value),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CONDICION", p);
            return Respuesta(dt);
        }

        private bdExpediente MapearExpediente(DataRow r)
        {
            return new bdExpediente
            {
                IdExpediente = Convert.ToInt32(r["IdExpediente"]),
                IdCliente = Convert.ToInt32(r["IdCliente"]),
                Folio = r["Folio"]?.ToString(),
                Nombres = r["Nombres"]?.ToString(),
                PrimerApellido = r["PrimerApellido"]?.ToString(),
                SegundoApellido = r["SegundoApellido"]?.ToString(),
                TipoSangre = r["TipoSangre"]?.ToString() ?? ""
            };
        }

        private bdRespuesta Respuesta(DataTable dt)
        {
            if (dt.Rows.Count == 0)
                return new bdRespuesta { Mensaje = "Operación completada exitosamente.", TipoMensaje = "success" };

            return new bdRespuesta
            {
                Mensaje = dt.Rows[0]["Mensaje"]?.ToString() ?? "",
                TipoMensaje = dt.Rows[0]["TipoMensaje"]?.ToString() ?? "info"
            };
        }
    }
}
