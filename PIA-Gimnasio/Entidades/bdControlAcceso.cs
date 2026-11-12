using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    /// <summary>
    /// Registro de torniquete / entrada y salida de socios a las sucursales.
    /// Mapea a la tabla dbo.CONTROL_ACCESO y procedimiento dbo.SP_CONTROL_ACCESO.
    /// </summary>
    public class bdControlAcceso
    {
        public int IdControlAcceso { get; set; }

        public DateTime FechaHoraEntrada { get; set; } = DateTime.Now;

        public DateTime? FechaHoraSalida { get; set; }

        [Required(ErrorMessage = "Selecciona un socio.")]
        [Range(1, int.MaxValue, ErrorMessage = "Socio no válido.")]
        public int IdCliente { get; set; }

        [Required(ErrorMessage = "Selecciona una sucursal.")]
        [Range(1, short.MaxValue, ErrorMessage = "Sucursal no válida.")]
        public short IdSucursal { get; set; }

        // Campos auxiliares de consulta
        public string? Folio { get; set; }
        public string? Cliente { get; set; }
        public string? Sucursal { get; set; }
        public int MinutosPermanencia { get; set; } = 0;
        public string? EstadoAcceso { get; set; }
    }
}
