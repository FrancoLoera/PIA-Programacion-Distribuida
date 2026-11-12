using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaUsuario
    {
        private readonly bdConexion _bd;

        public logicaUsuario(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Crear(string nombreCuenta, string contrasena, byte idRol, int idEmpleado, byte idEstatus = 1, int idUsuarioOperador = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 1),
                new SqlParameter("@NombreCuenta", nombreCuenta.Trim()),
                new SqlParameter("@Contrasena", contrasena.Trim()),
                new SqlParameter("@IdRol", idRol),
                new SqlParameter("@IdEmpleado", idEmpleado),
                new SqlParameter("@IdEstatus", idEstatus),
                new SqlParameter("@IdUsuarioOperador", idUsuarioOperador)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_USUARIO", p);
            return Respuesta(dt);
        }

        public bdUsuario? Obtener(int idUsuario)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_USUARIO", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return MapearUsuario(r);
        }

        public List<bdUsuario> Consultar(string? nombreCuenta = null, byte? idRol = null, byte? idEstatus = null)
        {
            List<SqlParameter> p = new List<SqlParameter>
            {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@NombreCuenta", !string.IsNullOrWhiteSpace(nombreCuenta) ? (object)nombreCuenta.Trim() : DBNull.Value),
                new SqlParameter("@IdRol", idRol.HasValue && idRol > 0 ? (object)idRol.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_USUARIO", p.ToArray());
            var list = new List<bdUsuario>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(MapearUsuario(r));
            }
            return list;
        }

        public bdRespuesta Modificar(int idUsuario, byte? idRol = null, byte? idEstatus = null, int idUsuarioOperador = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 4),
                new SqlParameter("@IdUsuario", idUsuario),
                new SqlParameter("@IdRol", idRol.HasValue && idRol > 0 ? (object)idRol.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value),
                new SqlParameter("@IdUsuarioOperador", idUsuarioOperador)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_USUARIO", p);
            return Respuesta(dt);
        }

        public bdRespuesta CambiarContrasena(int idUsuario, string nuevaContrasena, int idUsuarioOperador = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdUsuario", idUsuario),
                new SqlParameter("@Contrasena", nuevaContrasena.Trim()),
                new SqlParameter("@IdUsuarioOperador", idUsuarioOperador)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_USUARIO", p);
            return Respuesta(dt);
        }

        public bdUsuario? Autenticar(string cuenta, string contrasena, out string mensaje)
        {
            mensaje = "";
            SqlParameter[] p = {
                new SqlParameter("@Accion", 6),
                new SqlParameter("@NombreCuenta", cuenta.Trim()),
                new SqlParameter("@Contrasena", contrasena.Trim())
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_USUARIO", p);

            if (dt.Rows.Count == 0)
            {
                mensaje = "No se obtuvo respuesta del servidor.";
                return null;
            }

            DataRow r = dt.Rows[0];

            if (dt.Columns.Contains("TipoMensaje") && r["TipoMensaje"].ToString() == "warning")
            {
                mensaje = r["Mensaje"]?.ToString() ?? "Credenciales incorrectas.";
                return null;
            }

            if (dt.Columns.Contains("IdUsuario"))
            {
                mensaje = r["Mensaje"]?.ToString() ?? "Inicio de sesión correcto.";
                return new bdUsuario
                {
                    IdUsuario = Convert.ToInt32(r["IdUsuario"]),
                    NombreCuenta = r["NombreCuenta"].ToString() ?? "",
                    IdRol = Convert.ToByte(r["IdRol"]),
                    Rol = r["Rol"].ToString() ?? "",
                    IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                    Nombres = r["Nombres"]?.ToString(),
                    PrimerApellido = r["PrimerApellido"]?.ToString(),
                    SegundoApellido = r["SegundoApellido"]?.ToString(),
                    IdSucursal = Convert.ToInt16(r["IdSucursal"]),
                    Sucursal = r["Sucursal"]?.ToString()
                };
            }

            mensaje = "Error al procesar el inicio de sesión.";
            return null;
        }

        public List<bdRol> ConsultarRoles()
        {
            DataTable dt = _bd.EjecutarConsulta("SELECT IdRol, Nombre, Descripcion FROM dbo.ROL ORDER BY IdRol;");
            var list = new List<bdRol>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdRol
                {
                    IdRol = Convert.ToByte(r["IdRol"]),
                    Nombre = r["Nombre"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString()
                });
            }
            return list;
        }

        private bdUsuario MapearUsuario(DataRow r)
        {
            return new bdUsuario
            {
                IdUsuario = Convert.ToInt32(r["IdUsuario"]),
                NombreCuenta = r["NombreCuenta"].ToString() ?? "",
                FechaRegistro = r.Table.Columns.Contains("FechaRegistro") && r["FechaRegistro"] != DBNull.Value ? Convert.ToDateTime(r["FechaRegistro"]) : DateTime.MinValue,
                IdRol = Convert.ToByte(r["IdRol"]),
                Rol = r["Rol"]?.ToString() ?? "",
                IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                Empleado = r.Table.Columns.Contains("Empleado") ? r["Empleado"]?.ToString() : null,
                Nombres = r.Table.Columns.Contains("Nombres") ? r["Nombres"]?.ToString() : null,
                PrimerApellido = r.Table.Columns.Contains("PrimerApellido") ? r["PrimerApellido"]?.ToString() : null,
                SegundoApellido = r.Table.Columns.Contains("SegundoApellido") ? r["SegundoApellido"]?.ToString() : null,
                IdSucursal = r.Table.Columns.Contains("IdSucursal") && r["IdSucursal"] != DBNull.Value ? Convert.ToInt16(r["IdSucursal"]) : (short)0,
                Sucursal = r.Table.Columns.Contains("Sucursal") ? r["Sucursal"]?.ToString() : null,
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"]?.ToString() ?? ""
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
