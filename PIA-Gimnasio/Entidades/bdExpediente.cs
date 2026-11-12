using System;

namespace PIA_Gimnasio.Entidades
{
    public class bdExpediente
    {
        public int IdExpediente { get; set; }
        public int IdCliente { get; set; }
        public string? Folio { get; set; }
        public string? Nombres { get; set; }
        public string? PrimerApellido { get; set; }
        public string? SegundoApellido { get; set; }
        public string NombreCompleto => $"{Nombres} {PrimerApellido} {SegundoApellido}".Trim();
        public string TipoSangre { get; set; } = string.Empty;
    }

    public class bdCondicion
    {
        public byte IdCondicion { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Tipo { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
    }

    public class bdExpedienteCondicion
    {
        public int IdExpediente { get; set; }
        public byte IdCondicion { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Tipo { get; set; } = string.Empty;
        public string? Descripcion { get; set; }
        public string? Observaciones { get; set; }
    }
}
