using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdSucursal
    {
        public short IdSucursal { get; set; }

        [Required(ErrorMessage = "El nombre de la sucursal es obligatorio")]
        [StringLength(80, ErrorMessage = "El nombre no puede exceder 80 caracteres")]
        public string Nombre { get; set; } = "";

        [Required(ErrorMessage = "El teléfono es obligatorio")]
        [StringLength(20, ErrorMessage = "El teléfono no puede exceder 20 caracteres")]
        public string Telefono { get; set; } = "";

        [Required(ErrorMessage = "El número exterior es obligatorio")]
        [StringLength(20, ErrorMessage = "El número exterior no puede exceder 20 caracteres")]
        public string NumeroExterior { get; set; } = "";

        [StringLength(20, ErrorMessage = "El número interior no puede exceder 20 caracteres")]
        public string? NumeroInterior { get; set; }

        [Required(ErrorMessage = "La calle es obligatoria")]
        [StringLength(100, ErrorMessage = "La calle no puede exceder 100 caracteres")]
        public string Calle { get; set; } = "";

        [Required(ErrorMessage = "La colonia es obligatoria")]
        [StringLength(100, ErrorMessage = "La colonia no puede exceder 100 caracteres")]
        public string Colonia { get; set; } = "";

        [Required(ErrorMessage = "La ciudad es obligatoria")]
        [StringLength(100, ErrorMessage = "La ciudad no puede exceder 100 caracteres")]
        public string Ciudad { get; set; } = "";

        [Required(ErrorMessage = "El estado es obligatorio")]
        [StringLength(100, ErrorMessage = "El estado no puede exceder 100 caracteres")]
        public string Estado { get; set; } = "";

        [Required(ErrorMessage = "El aforo máximo es obligatorio")]
        [Range(1, 30000, ErrorMessage = "El aforo debe ser mayor a cero")]
        public short AforoMaximo { get; set; } = 100;

        [Required(ErrorMessage = "La hora de apertura es obligatoria")]
        public TimeSpan HoraApertura { get; set; } = new TimeSpan(6, 0, 0);

        [Required(ErrorMessage = "La hora de cierre es obligatoria")]
        public TimeSpan HoraCierre { get; set; } = new TimeSpan(22, 0, 0);

        public byte IdEstatus { get; set; } = 1;
        public string? Estatus { get; set; }

        public string DireccionCompleta => $"{Calle} #{NumeroExterior}{(NumeroInterior != null ? " Int. " + NumeroInterior : "")}, Col. {Colonia}, {Ciudad}, {Estado}";
    }
}
