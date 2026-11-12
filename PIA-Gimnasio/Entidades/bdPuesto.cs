using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdPuesto
    {
        public byte IdPuesto { get; set; }

        [Required(ErrorMessage = "El nombre del puesto es obligatorio.")]
        [StringLength(30, ErrorMessage = "El nombre no puede exceder 30 caracteres.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "La descripción del puesto es obligatoria.")]
        [StringLength(300, ErrorMessage = "La descripción no puede exceder 300 caracteres.")]
        public string Descripcion { get; set; } = string.Empty;
    }
}
