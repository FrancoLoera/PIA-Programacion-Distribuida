using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdSalon
    {
        public int IdSalon { get; set; }

        [Required(ErrorMessage = "El nombre o número del salón es obligatorio")]
        [StringLength(20, ErrorMessage = "El nombre no puede exceder 20 caracteres")]
        public string NombreNumero { get; set; } = "";

        [Required(ErrorMessage = "Debe seleccionar una sucursal")]
        [Range(1, short.MaxValue, ErrorMessage = "Seleccione una sucursal válida")]
        public short IdSucursal { get; set; }

        public string? Sucursal { get; set; }

        public byte IdEstatus { get; set; } = 1;
        public string? Estatus { get; set; }
    }
}
