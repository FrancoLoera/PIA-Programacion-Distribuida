using System;
using System.ComponentModel.DataAnnotations;

namespace PIA_Gimnasio.Entidades
{
    public class bdRutina
    {
        public int IdRutina { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public DateTime FechaAsignacion { get; set; }
        public string Objetivo { get; set; } = string.Empty;
        public int IdCliente { get; set; }
        public string? Folio { get; set; }
        public string? Cliente { get; set; }
        public int IdEmpleado { get; set; }
        public string? Entrenador { get; set; }
        public byte IdEstatus { get; set; }
        public string? Estatus { get; set; }
    }

    public class bdDetalleRutina
    {
        public int IdDetalleRutina { get; set; }
        public int IdRutina { get; set; }
        public byte DiaSemana { get; set; }
        public string NombreDia => DiaSemana switch
        {
            1 => "Lunes",
            2 => "Martes",
            3 => "Miércoles",
            4 => "Jueves",
            5 => "Viernes",
            6 => "Sábado",
            7 => "Domingo",
            _ => $"Día {DiaSemana}"
        };
        public byte Series { get; set; }
        public string Repeticiones { get; set; } = string.Empty;
        public short TiempoDescanso { get; set; } // En segundos
        public int IdEjercicio { get; set; }
        public string Ejercicio { get; set; } = string.Empty;
        public string? GrupoMuscular { get; set; }
        public string? Dificultad { get; set; }
    }

    public class bdEjercicio
    {
        public int IdEjercicio { get; set; }

        [Required(ErrorMessage = "El nombre del ejercicio es obligatorio.")]
        [StringLength(80, ErrorMessage = "Máximo 80 caracteres.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "La descripción es obligatoria.")]
        [StringLength(300, ErrorMessage = "Máximo 300 caracteres.")]
        public string? Descripcion { get; set; }

        [Range(1, short.MaxValue, ErrorMessage = "Selecciona un grupo muscular.")]
        public short IdGrupoMuscular { get; set; }

        public string? GrupoMuscular { get; set; }

        [Range(1, byte.MaxValue, ErrorMessage = "Selecciona una dificultad.")]
        public byte IdDificultad { get; set; }

        public string? Dificultad { get; set; }
        public string? Contraindicaciones { get; set; }
        public int UsosEnRutinas { get; set; }
    }

    public class bdGrupoMuscular
    {
        public short IdGrupoMuscular { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
    }

    public class bdDificultad
    {
        public byte IdDificultad { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
    }

    public class bdRutinaAlerta
    {
        public int IdRutina { get; set; }
        public string Rutina { get; set; } = string.Empty;
        public int IdCliente { get; set; }
        public string? Folio { get; set; }
        public string? Socio { get; set; }
        public int IdEmpleado { get; set; }
        public string? Entrenador { get; set; }
        public string EjercicioContraindicado { get; set; } = string.Empty;
        public string CondicionMedica { get; set; } = string.Empty;
    }
}
