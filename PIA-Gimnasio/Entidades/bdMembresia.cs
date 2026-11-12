using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    /// <summary>
    /// Catálogo de tipos de membresía (Planes: Bronce, Plata, Oro, etc.).
    /// Mapea a la tabla dbo.MEMBRESIA del modelo físico.
    /// </summary>
    public class bdMembresia
    {
        public byte IdMembresia { get; set; }

        [Required(ErrorMessage = "El nombre de la membresía es obligatorio.")]
        [StringLength(30, ErrorMessage = "Máximo 30 caracteres.")]
        public string Nombre { get; set; } = "";

        [Required(ErrorMessage = "El precio es obligatorio.")]
        [Range(0, 99999.99, ErrorMessage = "El precio debe ser mayor o igual a 0.")]
        public decimal Precio { get; set; }

        [Required(ErrorMessage = "La descripción es obligatoria.")]
        [StringLength(300, ErrorMessage = "Máximo 300 caracteres.")]
        public string Descripcion { get; set; } = "";

        public bool PermiteClases { get; set; } = false;

        [Range(0, 50, ErrorMessage = "El máximo de clases por semana debe ser entre 0 y 50.")]
        public byte MaxClasesSemana { get; set; } = 0;

        public bool SujetaAforo { get; set; } = false;
    }

    /// <summary>
    /// Suscripción asignada a un cliente.
    /// Mapea a la tabla dbo.SUSCRIPCION del modelo físico.
    /// </summary>
    public class bdSuscripcion
    {
        public int IdSuscripcion { get; set; }

        [Required(ErrorMessage = "La fecha de inicio es obligatoria.")]
        [DataType(DataType.Date)]
        public DateTime FechaInicio { get; set; } = DateTime.Today;

        [DataType(DataType.Date)]
        public DateTime? FechaVencimiento { get; set; }

        [Required(ErrorMessage = "Selecciona un socio.")]
        [Range(1, int.MaxValue, ErrorMessage = "Selecciona un socio válido.")]
        public int IdCliente { get; set; }

        [Required(ErrorMessage = "Selecciona un plan de membresía.")]
        [Range(1, 255, ErrorMessage = "Selecciona una membresía válida.")]
        public byte IdMembresia { get; set; }

        public byte IdEstatus { get; set; } = 2; // 2 = Activa por defecto en ESTATUS_SUSCRIPCION

        // Campos auxiliares devueltos por SP_SUSCRIPCION
        public string? Folio { get; set; }
        public string? SocioNombre { get; set; }
        public string? Membresia { get; set; }
        public decimal? Precio { get; set; }
        public string? Estatus { get; set; }
        public string? EstadoVigencia { get; set; }
    }
}
