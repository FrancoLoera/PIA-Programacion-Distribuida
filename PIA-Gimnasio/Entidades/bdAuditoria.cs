using System;

namespace PIA_Gimnasio.Entidades
{
    public class bdAuditoria
    {
        public long IdAuditoria { get; set; }
        public string NombreTabla { get; set; } = string.Empty;
        public int IdRegistro { get; set; }
        public string TipoOperacion { get; set; } = string.Empty;
        public DateTime FechaOperacion { get; set; }
        public string? ValoresAnteriores { get; set; }
        public string? ValoresNuevos { get; set; }
        public int? IdUsuario { get; set; }
        public string? NombreCuenta { get; set; }
        public string? RolUsuario { get; set; }
        public string? Operador { get; set; }
    }
}
