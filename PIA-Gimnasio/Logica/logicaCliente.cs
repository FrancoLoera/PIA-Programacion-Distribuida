using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaCliente
    {
        private readonly bdConexion _bd;

        public logicaCliente(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Guardar(bdCliente cliente, int idUsuario = 1)
        {
            int accion = cliente.IdCliente == 0 ? 1 : 4;

            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdCliente", cliente.IdCliente),
                new SqlParameter("@Nombres", Valor(cliente.Nombres?.Trim())),
                new SqlParameter("@PrimerApellido", Valor(cliente.PrimerApellido?.Trim())),
                new SqlParameter("@SegundoApellido", Valor(cliente.SegundoApellido?.Trim())),
                new SqlParameter("@Telefono", Valor(cliente.Telefono?.Trim())),
                new SqlParameter("@Correo", Valor(cliente.Correo?.ToLower().Trim())),
                new SqlParameter("@FechaNacimiento", cliente.FechaNacimiento.HasValue ? (object)cliente.FechaNacimiento.Value.Date : DBNull.Value),
                new SqlParameter("@IdSucursal", cliente.IdSucursal),
                new SqlParameter("@IdEstatus", cliente.IdEstatus),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLIENTE", p);
            return Respuesta(dt);
        }

        public bdCliente? Obtener(int id)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdCliente", id)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLIENTE", p);
            if (dt.Rows.Count == 0)
                return null;

            DataRow r = dt.Rows[0];
            return new bdCliente
            {
                IdCliente = Convert.ToInt32(r["IdCliente"]),
                Folio = r["Folio"].ToString(),
                Nombres = r["Nombres"].ToString(),
                PrimerApellido = r["PrimerApellido"].ToString(),
                SegundoApellido = r["SegundoApellido"] == DBNull.Value ? null : r["SegundoApellido"].ToString(),
                Telefono = r["Telefono"].ToString(),
                Correo = r["Correo"].ToString(),
                FechaNacimiento = r["FechaNacimiento"] == DBNull.Value ? null : Convert.ToDateTime(r["FechaNacimiento"]),
                FechaInscripcion = r["FechaInscripcion"] == DBNull.Value ? null : Convert.ToDateTime(r["FechaInscripcion"]),
                IdSucursal = Convert.ToInt16(r["IdSucursal"]),
                Sucursal = r["Sucursal"].ToString(),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"].ToString()
            };
        }

        public DataTable Consultar(string? buscar = null, short? idSucursal = null, byte? idEstatus = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@Nombres", Valor(buscar)),
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value)
            };

            return _bd.EjecutarStoredProcedure("dbo.SP_CLIENTE", p);
        }

        public bdRespuesta DarDeBaja(int idCliente, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLIENTE", p);
            return Respuesta(dt);
        }

        public bdRespuesta Reactivar(int idCliente, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 6),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_CLIENTE", p);
            return Respuesta(dt);
        }

        public List<bdSucursal> ListarSucursalesActivas()
        {
            List<bdSucursal> lista = new List<bdSucursal>();
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@IdEstatus", 1) // Activas
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_SUCURSAL", p);
            foreach (DataRow r in dt.Rows)
            {
                lista.Add(new bdSucursal
                {
                    IdSucursal = Convert.ToInt16(r["IdSucursal"]),
                    Nombre = r["Nombre"].ToString() ?? "",
                    Ciudad = r["Ciudad"]?.ToString() ?? "",
                    IdEstatus = Convert.ToByte(r["IdEstatus"])
                });
            }
            return lista;
        }

        private bdRespuesta Respuesta(DataTable dt)
        {
            if (dt.Rows.Count == 0)
            {
                return new bdRespuesta { Mensaje = "Operación completada.", TipoMensaje = "success" };
            }

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
