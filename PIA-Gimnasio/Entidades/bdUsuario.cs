using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdUsuario
    {
        public int IdUsuario { get; set; }

        [Required(ErrorMessage = "El nombre de cuenta es obligatorio")]
        public string NombreCuenta { get; set; } = "";

        [Required(ErrorMessage = "La contraseña es obligatoria")]
        public string Contrasena { get; set; } = "";

        public DateTime FechaRegistro { get; set; }

        public byte IdRol { get; set; }
        public string Rol { get; set; } = "";

        public int IdEmpleado { get; set; }
        public string? Empleado { get; set; }
        public string? Nombres { get; set; }
        public string? PrimerApellido { get; set; }
        public string? SegundoApellido { get; set; }

        public short IdSucursal { get; set; }
        public string? Sucursal { get; set; }

        public byte IdEstatus { get; set; }
        public string? Estatus { get; set; }

        public string NombreCompleto => !string.IsNullOrWhiteSpace(Empleado)
            ? Empleado
            : $"{PrimerApellido} {(SegundoApellido != null ? SegundoApellido + " " : "")}{Nombres}".Trim();
    }

    public class bdRol
    {
        public byte IdRol { get; set; }
        public string Nombre { get; set; } = "";
        public string? Descripcion { get; set; }
    }
}
