using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaEmpleado
    {
        private readonly bdConexion _bd;

        public logicaEmpleado(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Guardar(bdEmpleado e, int idUsuario = 1)
        {
            int accion = e.IdEmpleado == 0 ? 1 : 4; // 1 Insert, 4 Update
            SqlParameter[] p = {
                new SqlParameter("@Accion", accion),
                new SqlParameter("@IdEmpleado", e.IdEmpleado),
                new SqlParameter("@Nombres", Valor(e.Nombres)),
                new SqlParameter("@PrimerApellido", Valor(e.PrimerApellido)),
                new SqlParameter("@SegundoApellido", Valor(e.SegundoApellido)),
                new SqlParameter("@CURP", Valor(e.CURP)),
                new SqlParameter("@Telefono", Valor(e.Telefono)),
                new SqlParameter("@Correo", Valor(e.Correo)),
                new SqlParameter("@FechaNacimiento", e.FechaNacimiento),
                new SqlParameter("@FechaContratacion", e.FechaContratacion),
                new SqlParameter("@IdPuesto", e.IdPuesto),
                new SqlParameter("@IdSucursal", e.IdSucursal),
                new SqlParameter("@IdEstatus", e.IdEstatus),
                new SqlParameter("@IdEspecialidad", (object?)e.IdEspecialidad ?? DBNull.Value),
                new SqlParameter("@IdUsuario", idUsuario)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EMPLEADO", p);
            return Respuesta(dt);
        }

        public bdEmpleado? Obtener(int id)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 2),
                new SqlParameter("@IdEmpleado", id)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EMPLEADO", p);
            if (dt.Rows.Count == 0) return null;
            DataRow r = dt.Rows[0];
            return new bdEmpleado
            {
                IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                Nombres = r["Nombres"]?.ToString() ?? "",
                PrimerApellido = r["PrimerApellido"]?.ToString() ?? "",
                SegundoApellido = r["SegundoApellido"] == DBNull.Value ? null : r["SegundoApellido"].ToString(),
                CURP = r["CURP"]?.ToString() ?? "",
                Telefono = r["Telefono"]?.ToString() ?? "",
                Correo = r["Correo"]?.ToString() ?? "",
                FechaNacimiento = (DateTime)r["FechaNacimiento"],
                FechaContratacion = (DateTime)r["FechaContratacion"],
                IdPuesto = Convert.ToByte(r["IdPuesto"]),
                IdSucursal = Convert.ToInt16(r["IdSucursal"]),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                IdEspecialidad = r["IdEspecialidad"] == DBNull.Value ? (byte?)null : Convert.ToByte(r["IdEspecialidad"]),
                // Aux fields (populated in query via joins)
                Estatus = r["Estatus"]?.ToString(),
                Puesto = r["Puesto"]?.ToString(),
                Sucursal = r["Sucursal"]?.ToString(),
                Especialidad = r["Especialidad"]?.ToString()
            };
        }

        public DataTable Consultar(string? buscar = null, byte? idPuesto = null, byte? idEstatus = null, short? idSucursal = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@Nombres", Valor(buscar)),
                new SqlParameter("@IdPuesto", idPuesto.HasValue && idPuesto > 0 ? (object)idPuesto.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value),
                new SqlParameter("@IdSucursal", idSucursal.HasValue && idSucursal > 0 ? (object)idSucursal.Value : DBNull.Value)
            };
            return _bd.EjecutarStoredProcedure("dbo.SP_EMPLEADO", p);
        }

        public bdRespuesta DarDeBaja(int id, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 5),
                new SqlParameter("@IdEmpleado", id),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EMPLEADO", p);
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

        private object Valor(string? texto) => string.IsNullOrWhiteSpace(texto) ? DBNull.Value : (object)texto.Trim();
    }
}
