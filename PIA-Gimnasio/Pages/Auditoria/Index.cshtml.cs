using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Auditoria
{
    [Authorize(Roles = "Administrador")]
    public class IndexModel : PageModel
    {
        private readonly logicaAuditoria _logicaAuditoria;
        private readonly logicaUsuario _logicaUsuario;

        public IndexModel(logicaAuditoria logicaAuditoria, logicaUsuario logicaUsuario)
        {
            _logicaAuditoria = logicaAuditoria;
            _logicaUsuario = logicaUsuario;
        }

        [BindProperty(SupportsGet = true)]
        public string? FiltroTabla { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? FiltroOperacion { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroUsuario { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroIdRegistro { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FechaInicio { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FechaFin { get; set; }

        public List<bdAuditoria> Auditorias { get; set; } = new List<bdAuditoria>();
        public List<string> TablasAuditadas { get; set; } = new List<string>();
        public List<bdUsuario> Usuarios { get; set; } = new List<bdUsuario>();

        public void OnGet()
        {
            TablasAuditadas = _logicaAuditoria.ConsultarTablasAuditadas();
            Usuarios = _logicaUsuario.Consultar();
            Auditorias = _logicaAuditoria.Consultar(FiltroTabla, FiltroIdRegistro, FiltroUsuario, FiltroOperacion, FechaInicio, FechaFin);
        }
    }
}
