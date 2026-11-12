using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Expedientes
{
    [Authorize(Roles = "Administrador,Recepcionista,Entrenador")]
    public class IndexModel : PageModel
    {
        private readonly logicaExpediente _logicaExpediente;
        private readonly logicaCliente _logicaCliente;

        public IndexModel(logicaExpediente logicaExpediente, logicaCliente logicaCliente)
        {
            _logicaExpediente = logicaExpediente;
            _logicaCliente = logicaCliente;
        }

        [BindProperty(SupportsGet = true)]
        public int? FiltroCliente { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? FiltroTipoSangre { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? ExpedienteDetalle { get; set; }

        public List<bdExpediente> Expedientes { get; set; } = new List<bdExpediente>();
        public List<bdCondicion> CatalogoCondiciones { get; set; } = new List<bdCondicion>();
        public DataTable Socios { get; set; } = new DataTable();
        public bdExpediente? ExpedienteActual { get; set; }
        public List<bdExpedienteCondicion> CondicionesActuales { get; set; } = new List<bdExpedienteCondicion>();

        // Crear expediente
        [BindProperty]
        public int IdClienteNuevo { get; set; }

        [BindProperty]
        public string TipoSangreNuevo { get; set; } = "";

        // Editar tipo de sangre
        [BindProperty]
        public int IdExpedienteEditar { get; set; }

        [BindProperty]
        public string TipoSangreEditar { get; set; } = "";

        // Asociar condición
        [BindProperty]
        public int IdExpedienteCondicion { get; set; }

        [BindProperty]
        public byte IdCondicionAsociar { get; set; }

        [BindProperty]
        public string? ObservacionesCondicion { get; set; }

        // Desvincular condición
        [BindProperty]
        public int IdExpedienteDesvincular { get; set; }

        [BindProperty]
        public byte IdCondicionDesvincular { get; set; }

        // Agregar condición al catálogo
        [BindProperty]
        public string NombreCondicionCatalogo { get; set; } = "";

        [BindProperty]
        public string TipoCondicionCatalogo { get; set; } = "";

        [BindProperty]
        public string? DescripcionCondicionCatalogo { get; set; }

        [TempData]
        public string Mensaje { get; set; } = "";

        [TempData]
        public string TipoMensaje { get; set; } = "";

        public bool PuedeEditar => User.IsInRole("Administrador") || User.IsInRole("Entrenador");

        public void OnGet()
        {
            CargarDatos();
        }

        public IActionResult OnPostCrear()
        {
            if (IdClienteNuevo <= 0 || string.IsNullOrWhiteSpace(TipoSangreNuevo))
            {
                TipoMensaje = "warning";
                Mensaje = "Selecciona un socio y su tipo de sangre.";
                return RedirectToPage(new { FiltroCliente, FiltroTipoSangre });
            }

            var resp = _logicaExpediente.Registrar(IdClienteNuevo, TipoSangreNuevo, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { FiltroCliente = IdClienteNuevo });
        }

        public IActionResult OnPostActualizarTipo()
        {
            if (IdExpedienteEditar <= 0 || string.IsNullOrWhiteSpace(TipoSangreEditar))
            {
                TipoMensaje = "warning";
                Mensaje = "Indica el tipo de sangre a actualizar.";
                return RedirectToPage(new { ExpedienteDetalle = IdExpedienteEditar });
            }

            var resp = _logicaExpediente.ModificarTipoSangre(IdExpedienteEditar, TipoSangreEditar, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { ExpedienteDetalle = IdExpedienteEditar });
        }

        public IActionResult OnPostAsociarCondicion()
        {
            if (IdExpedienteCondicion <= 0 || IdCondicionAsociar <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Selecciona la condición médica a asociar.";
                return RedirectToPage(new { ExpedienteDetalle = IdExpedienteCondicion });
            }

            var resp = _logicaExpediente.AsociarCondicion(IdExpedienteCondicion, IdCondicionAsociar, ObservacionesCondicion, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { ExpedienteDetalle = IdExpedienteCondicion });
        }

        public IActionResult OnPostDesvincularCondicion()
        {
            if (IdExpedienteDesvincular <= 0 || IdCondicionDesvincular <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Datos de condición incompletos.";
                return RedirectToPage();
            }

            var resp = _logicaExpediente.DesvincularCondicion(IdExpedienteDesvincular, IdCondicionDesvincular, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { ExpedienteDetalle = IdExpedienteDesvincular });
        }

        public IActionResult OnPostNuevaCondicionCatalogo()
        {
            if (string.IsNullOrWhiteSpace(NombreCondicionCatalogo) || string.IsNullOrWhiteSpace(TipoCondicionCatalogo))
            {
                TipoMensaje = "warning";
                Mensaje = "El nombre y tipo de condición son obligatorios.";
                return RedirectToPage(new { ExpedienteDetalle });
            }

            var resp = _logicaExpediente.RegistrarCondicionCatalogo(NombreCondicionCatalogo, TipoCondicionCatalogo, DescripcionCondicionCatalogo, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { ExpedienteDetalle });
        }

        private void CargarDatos()
        {
            Expedientes = _logicaExpediente.Consultar(FiltroCliente, FiltroTipoSangre);
            CatalogoCondiciones = _logicaExpediente.CatalogoCondiciones();
            Socios = _logicaCliente.Consultar(null, null, 1);

            if (ExpedienteDetalle.HasValue && ExpedienteDetalle > 0)
            {
                ExpedienteActual = _logicaExpediente.ObtenerPorId(ExpedienteDetalle.Value);
                if (ExpedienteActual != null)
                {
                    CondicionesActuales = _logicaExpediente.ObtenerCondiciones(ExpedienteDetalle.Value);
                }
            }
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
