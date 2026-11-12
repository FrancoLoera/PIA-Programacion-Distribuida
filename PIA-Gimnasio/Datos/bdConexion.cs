using System.Data;
using Microsoft.Data.SqlClient;

namespace PIA_Gimnasio.Datos
{
    public class bdConexion
    {
        private readonly string _cadena;

        public bdConexion(IConfiguration config)
        {
            _cadena = config.GetConnectionString("bdConexion")
                ?? throw new Exception("No se encontró la cadena de conexión 'bdConexion' en appsettings.json");
        }

        public DataTable EjecutarStoredProcedure(string nombreSP, SqlParameter[]? parametros = null)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(_cadena))
            {
                using (SqlCommand cmd = new SqlCommand(nombreSP, con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (parametros != null && parametros.Length > 0)
                    {
                        cmd.Parameters.AddRange(parametros);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }

        public DataTable EjecutarConsulta(string consultaSql, SqlParameter[]? parametros = null)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(_cadena))
            {
                using (SqlCommand cmd = new SqlCommand(consultaSql, con))
                {
                    cmd.CommandType = CommandType.Text;
                    if (parametros != null && parametros.Length > 0)
                    {
                        cmd.Parameters.AddRange(parametros);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }
    }
}
