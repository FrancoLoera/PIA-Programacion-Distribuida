using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using PIA_Gimnasio.Datos;
using PIA_Gimnasio.Entidades;

namespace PIA_Gimnasio.Logica
{
    public class logicaRutina
    {
        private readonly bdConexion _bd;

        public logicaRutina(bdConexion bd)
        {
            _bd = bd;
        }

        public bdRespuesta Crear(string nombre, string objetivo, int idCliente, int idEmpleado, DateTime? fechaAsignacion = null, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)1),
                new SqlParameter("@Nombre", nombre.Trim()),
                new SqlParameter("@Objetivo", objetivo.Trim()),
                new SqlParameter("@IdCliente", idCliente),
                new SqlParameter("@IdEmpleado", idEmpleado),
                new SqlParameter("@FechaAsignacion", fechaAsignacion.HasValue ? (object)fechaAsignacion.Value.Date : DBNull.Value),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            return Respuesta(dt);
        }

        public bdRutina? ObtenerPorId(int idRutina)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)2),
                new SqlParameter("@IdRutina", idRutina)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            if (dt.Rows.Count == 0) return null;

            DataRow r = dt.Rows[0];
            return MapearRutina(r);
        }

        public List<bdRutina> Consultar(int? idCliente = null, int? idEmpleado = null, byte? idEstatus = null, string? nombre = null)
        {
            List<SqlParameter> p = new List<SqlParameter>
            {
                new SqlParameter("@Accion", (byte)3),
                new SqlParameter("@IdCliente", idCliente.HasValue && idCliente > 0 ? (object)idCliente.Value : DBNull.Value),
                new SqlParameter("@IdEmpleado", idEmpleado.HasValue && idEmpleado > 0 ? (object)idEmpleado.Value : DBNull.Value),
                new SqlParameter("@IdEstatus", idEstatus.HasValue && idEstatus > 0 ? (object)idEstatus.Value : DBNull.Value),
                new SqlParameter("@Nombre", !string.IsNullOrWhiteSpace(nombre) ? (object)nombre.Trim() : DBNull.Value)
            };

            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p.ToArray());
            var list = new List<bdRutina>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(MapearRutina(r));
            }
            return list;
        }

        public bdRespuesta Modificar(int idRutina, string nombre, string objetivo, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)4),
                new SqlParameter("@IdRutina", idRutina),
                new SqlParameter("@Nombre", nombre.Trim()),
                new SqlParameter("@Objetivo", objetivo.Trim()),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            return Respuesta(dt);
        }

        public bdRespuesta CambiarEstatus(int idRutina, byte idEstatus, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)5),
                new SqlParameter("@IdRutina", idRutina),
                new SqlParameter("@IdEstatus", idEstatus), // 2 = Finalizada, 3 = Suspendida
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            return Respuesta(dt);
        }

        public bdRespuesta AgregarEjercicio(int idRutina, int idEjercicio, byte diaSemana, byte series, string repeticiones, short tiempoDescanso, bool ignorarContraindicacion = false, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)6),
                new SqlParameter("@IdRutina", idRutina),
                new SqlParameter("@IdEjercicio", idEjercicio),
                new SqlParameter("@DiaSemana", diaSemana),
                new SqlParameter("@Series", series),
                new SqlParameter("@Repeticiones", repeticiones.Trim()),
                new SqlParameter("@TiempoDescanso", tiempoDescanso),
                new SqlParameter("@IgnorarContraindicacion", ignorarContraindicacion),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            return Respuesta(dt);
        }

        public List<bdDetalleRutina> ListarDetalles(int idRutina)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)8),
                new SqlParameter("@IdRutina", idRutina)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            var list = new List<bdDetalleRutina>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdDetalleRutina
                {
                    IdDetalleRutina = Convert.ToInt32(r["IdDetalleRutina"]),
                    IdRutina = Convert.ToInt32(r["IdRutina"]),
                    DiaSemana = Convert.ToByte(r["DiaSemana"]),
                    Series = Convert.ToByte(r["Series"]),
                    Repeticiones = r["Repeticiones"]?.ToString() ?? "",
                    TiempoDescanso = Convert.ToInt16(r["TiempoDescanso"]),
                    IdEjercicio = Convert.ToInt32(r["IdEjercicio"]),
                    Ejercicio = r["Ejercicio"]?.ToString() ?? "",
                    GrupoMuscular = r["GrupoMuscular"]?.ToString(),
                    Dificultad = r["Dificultad"]?.ToString()
                });
            }
            return list;
        }

        public bdRespuesta QuitarEjercicio(int idDetalleRutina, int idUsuario = 1)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)10),
                new SqlParameter("@IdDetalleRutina", idDetalleRutina),
                new SqlParameter("@IdUsuario", idUsuario)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            return Respuesta(dt);
        }

        public List<bdRutinaAlerta> ConsultarAlertas()
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", (byte)11)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_RUTINA", p);
            var list = new List<bdRutinaAlerta>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdRutinaAlerta
                {
                    IdRutina = Convert.ToInt32(r["IdRutina"]),
                    Rutina = r["Rutina"]?.ToString() ?? "",
                    IdCliente = Convert.ToInt32(r["IdCliente"]),
                    Folio = r["Folio"]?.ToString(),
                    Socio = r["Socio"]?.ToString(),
                    IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                    Entrenador = r["Entrenador"]?.ToString(),
                    EjercicioContraindicado = r["EjercicioContraindicado"]?.ToString() ?? "",
                    CondicionMedica = r["CondicionMedica"]?.ToString() ?? ""
                });
            }
            return list;
        }

        // Catálogos auxiliares de ejercicios y grupos musculares
        public List<bdEjercicio> ConsultarEjercicios(string? nombre = null, short? idGrupoMuscular = null, byte? idDificultad = null)
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3),
                new SqlParameter("@Nombre", !string.IsNullOrWhiteSpace(nombre) ? (object)nombre.Trim() : DBNull.Value),
                new SqlParameter("@IdGrupoMuscular", idGrupoMuscular.HasValue && idGrupoMuscular > 0 ? (object)idGrupoMuscular.Value : DBNull.Value),
                new SqlParameter("@IdDificultad", idDificultad.HasValue && idDificultad > 0 ? (object)idDificultad.Value : DBNull.Value)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_EJERCICIO", p);
            var list = new List<bdEjercicio>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdEjercicio
                {
                    IdEjercicio = Convert.ToInt32(r["IdEjercicio"]),
                    Nombre = r["Nombre"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString(),
                    IdGrupoMuscular = Convert.ToInt16(r["IdGrupoMuscular"]),
                    GrupoMuscular = r["GrupoMuscular"]?.ToString(),
                    IdDificultad = Convert.ToByte(r["IdDificultad"]),
                    Dificultad = r["Dificultad"]?.ToString()
                });
            }
            return list;
        }

        public List<bdGrupoMuscular> ConsultarGruposMusculares()
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_GRUPO_MUSCULAR", p);
            var list = new List<bdGrupoMuscular>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdGrupoMuscular
                {
                    IdGrupoMuscular = Convert.ToInt16(r["IdGrupoMuscular"]),
                    Nombre = r["Nombre"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString()
                });
            }
            return list;
        }

        public List<bdDificultad> ConsultarDificultades()
        {
            SqlParameter[] p = {
                new SqlParameter("@Accion", 3)
            };
            DataTable dt = _bd.EjecutarStoredProcedure("dbo.SP_DIFICULTAD", p);
            var list = new List<bdDificultad>();
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new bdDificultad
                {
                    IdDificultad = Convert.ToByte(r["IdDificultad"]),
                    Nombre = r["Nombre"]?.ToString() ?? "",
                    Descripcion = r["Descripcion"]?.ToString()
                });
            }
            return list;
        }

        private bdRutina MapearRutina(DataRow r)
        {
            return new bdRutina
            {
                IdRutina = Convert.ToInt32(r["IdRutina"]),
                Nombre = r["Nombre"]?.ToString() ?? "",
                FechaAsignacion = Convert.ToDateTime(r["FechaAsignacion"]),
                Objetivo = r["Objetivo"]?.ToString() ?? "",
                IdCliente = Convert.ToInt32(r["IdCliente"]),
                Folio = r["Folio"]?.ToString(),
                Cliente = r["Cliente"]?.ToString(),
                IdEmpleado = Convert.ToInt32(r["IdEmpleado"]),
                Entrenador = r["Entrenador"]?.ToString(),
                IdEstatus = Convert.ToByte(r["IdEstatus"]),
                Estatus = r["Estatus"]?.ToString()
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
