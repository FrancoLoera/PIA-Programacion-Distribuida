using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    /// <summary>
    /// Registro de reserva de un socio para una clase deportiva y su asistencia.
    /// Mapea a la tabla dbo.RESERVA y procedimiento dbo.SP_RESERVA.
    /// </summary>
    public class bdReserva
    {
        public int IdReserva { get; set; }

        public DateTime FechaHora { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Selecciona una clase.")]
        [Range(1, int.MaxValue, ErrorMessage = "Clase no válida.")]
        public int IdClase { get; set; }

        [Required(ErrorMessage = "Selecciona un socio.")]
        [Range(1, int.MaxValue, ErrorMessage = "Socio no válido.")]
        public int IdCliente { get; set; }

        public int IdEmpleado { get; set; }

        public byte IdEstatus { get; set; } = 1; // 1=Confirmada, 2=Cancelada, 3=Asistió, 4=No asistió

        // Campos auxiliares de consulta
        public string? Clase { get; set; }
        public DateTime? FechaClase { get; set; }
        public TimeSpan? HoraInicio { get; set; }
        public TimeSpan? HoraFin { get; set; }
        public string? Cliente { get; set; }
        public string? Folio { get; set; }
        public string? Capturo { get; set; }
        public string? Estatus { get; set; }
    }
}
