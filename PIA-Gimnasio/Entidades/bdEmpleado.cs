using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdEmpleado
    {
        public int IdEmpleado { get; set; }

        [Required(ErrorMessage = "Los nombres son obligatorios")]
        [StringLength(50, ErrorMessage = "Los nombres no pueden exceder 50 caracteres")]
        public string Nombres { get; set; } = string.Empty;

        [Required(ErrorMessage = "El primer apellido es obligatorio")]
        [StringLength(50, ErrorMessage = "El primer apellido no puede exceder 50 caracteres")]
        public string PrimerApellido { get; set; } = string.Empty;

        [StringLength(50, ErrorMessage = "El segundo apellido no puede exceder 50 caracteres")]
        public string? SegundoApellido { get; set; }

        [Required(ErrorMessage = "CURP es obligatorio")]
        [StringLength(18, MinimumLength = 18, ErrorMessage = "CURP debe tener 18 caracteres")]
        public string CURP { get; set; } = string.Empty;

        [Required(ErrorMessage = "Teléfono es obligatorio")]
        [StringLength(20, ErrorMessage = "Teléfono no puede exceder 20 caracteres")]
        public string Telefono { get; set; } = string.Empty;

        [Required(ErrorMessage = "Correo es obligatorio")]
        [StringLength(254, ErrorMessage = "Correo no puede exceder 254 caracteres")]
        [EmailAddress(ErrorMessage = "Formato de correo no válido")]
        public string Correo { get; set; } = string.Empty;

        [Required(ErrorMessage = "Fecha de nacimiento es obligatoria")]
        public DateTime FechaNacimiento { get; set; }

        [Required(ErrorMessage = "Fecha de contratación es obligatoria")]
        public DateTime FechaContratacion { get; set; }

        [Required(ErrorMessage = "Puesto es obligatorio")]
        public byte IdPuesto { get; set; }

        [Required(ErrorMessage = "Sucursal es obligatoria")]
        public short IdSucursal { get; set; }

        [Required(ErrorMessage = "Estatus es obligatorio")]
        public byte IdEstatus { get; set; } = 1;

        // Opcional: asignación directa de una especialidad (para creación/edición rápida)
        public byte? IdEspecialidad { get; set; }

        // Campos auxiliares para presentación (no vienen directamente de la tabla)
        public string? Estatus { get; set; }
        public string? Puesto { get; set; }
        public string? Sucursal { get; set; }
        public string? Especialidad { get; set; }
    }
}
