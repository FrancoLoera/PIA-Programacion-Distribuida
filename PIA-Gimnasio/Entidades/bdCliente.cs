using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdCliente
    {
        public int IdCliente { get; set; }

        public string? Folio { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio")]
        [StringLength(50, ErrorMessage = "El nombre no puede exceder 50 caracteres")]
        public string? Nombres { get; set; }

        [Required(ErrorMessage = "El primer apellido es obligatorio")]
        [StringLength(50, ErrorMessage = "El primer apellido no puede exceder 50 caracteres")]
        public string? PrimerApellido { get; set; }

        [StringLength(50, ErrorMessage = "El segundo apellido no puede exceder 50 caracteres")]
        public string? SegundoApellido { get; set; }

        [Required(ErrorMessage = "El teléfono es obligatorio")]
        [StringLength(20, ErrorMessage = "El teléfono no puede exceder 20 caracteres")]
        public string? Telefono { get; set; }

        [Required(ErrorMessage = "El correo electrónico es obligatorio")]
        [EmailAddress(ErrorMessage = "El correo electrónico no es válido")]
        [StringLength(254, ErrorMessage = "El correo no puede exceder 254 caracteres")]
        public string? Correo { get; set; }

        [Required(ErrorMessage = "La fecha de nacimiento es obligatoria")]
        [DataType(DataType.Date)]
        public DateTime? FechaNacimiento { get; set; }

        [DataType(DataType.Date)]
        public DateTime? FechaInscripcion { get; set; }

        [Required(ErrorMessage = "Debe seleccionar una sucursal")]
        [Range(1, short.MaxValue, ErrorMessage = "Debe seleccionar una sucursal válida")]
        public short IdSucursal { get; set; }

        public string? Sucursal { get; set; }

        public byte IdEstatus { get; set; } = 1;

        public string? Estatus { get; set; }

        public string NombreCompleto => $"{PrimerApellido} {(SegundoApellido != null ? SegundoApellido + " " : "")}{Nombres}".Trim();
    }
}
