using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    /// <summary>
    /// Representa una clase grupal o sesión deportiva en un salón del gimnasio.
    /// Mapea a la tabla dbo.CLASE y procedimientos dbo.SP_CLASE.
    /// </summary>
    public class bdClase
    {
        public int IdClase { get; set; }

        [Required(ErrorMessage = "El nombre de la clase es obligatorio.")]
        [StringLength(80, ErrorMessage = "Máximo 80 caracteres.")]
        public string Nombre { get; set; } = "";

        [Required(ErrorMessage = "La fecha es obligatoria.")]
        [DataType(DataType.Date)]
        public DateTime Fecha { get; set; } = DateTime.Today;

        [Required(ErrorMessage = "La hora de inicio es obligatoria.")]
        [DataType(DataType.Time)]
        public TimeSpan HoraInicio { get; set; } = new TimeSpan(8, 0, 0);

        [Required(ErrorMessage = "La hora de fin es obligatoria.")]
        [DataType(DataType.Time)]
        public TimeSpan HoraFin { get; set; } = new TimeSpan(9, 0, 0);

        [Required(ErrorMessage = "El cupo máximo es obligatorio.")]
        [Range(1, 500, ErrorMessage = "El cupo debe ser mayor a 0.")]
        public short CupoMaximo { get; set; } = 20;

        [Required(ErrorMessage = "Selecciona un salón.")]
        [Range(1, int.MaxValue, ErrorMessage = "Selecciona un salón válido.")]
        public int IdSalon { get; set; }

        [Required(ErrorMessage = "Selecciona un instructor.")]
        [Range(1, int.MaxValue, ErrorMessage = "Selecciona un instructor válido.")]
        public int IdEmpleado { get; set; }

        public byte? IdEspecialidad { get; set; }

        public byte IdEstatus { get; set; } = 1; // 1 = Programada, 2 = Cancelada, 3 = Finalizada

        // Campos auxiliares de consulta (rellenados por SP_CLASE)
        public string? Salon { get; set; }
        public short? IdSucursal { get; set; }
        public string? Sucursal { get; set; }
        public string? Empleado { get; set; }
        public string? EspecialidadRequerida { get; set; }
        public string? Estatus { get; set; }
        public int LugaresOcupados { get; set; } = 0;
    }
}
