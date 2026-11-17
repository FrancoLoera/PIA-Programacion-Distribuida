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
        public List<int> SociosConExpediente { get; set; } = new List<int>();
        public List<bdCondicion> CondicionesDisponibles => CatalogoCondiciones.FindAll(c => !CondicionesActuales.Exists(a => a.IdCondicion == c.IdCondicion));

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

        public bool PuedeEditar => User.IsInRole("Administrador") || User.IsInRole("Recepcionista");
        public bool EsAdministrador => User.IsInRole("Administrador");
        public bool EsEntrenador => User.IsInRole("Entrenador");

        public void OnGet()
        {
            CargarDatos();
        }

        public IActionResult OnPostCrear()
        {
            if (!PuedeEditar)
                return Forbid();

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
            if (!PuedeEditar)
                return Forbid();

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
            if (!PuedeEditar)
                return Forbid();

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
            if (!PuedeEditar)
                return Forbid();

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
            if (!EsAdministrador)
                return Forbid();

            if (string.IsNullOrWhiteSpace(NombreCondicionCatalogo) || string.IsNullOrWhiteSpace(TipoCondicionCatalogo)
                || string.IsNullOrWhiteSpace(DescripcionCondicionCatalogo))
            {
                TipoMensaje = "warning";
                Mensaje = "El nombre, el tipo y la descripción de la condición son obligatorios.";
                return RedirectToPage(new { ExpedienteDetalle });
            }

            var resp = _logicaExpediente.RegistrarCondicionCatalogo(NombreCondicionCatalogo, TipoCondicionCatalogo, DescripcionCondicionCatalogo, ObtenerIdUsuario());
            Mensaje = resp.Mensaje;
            TipoMensaje = resp.TipoMensaje;
            return RedirectToPage(new { ExpedienteDetalle });
        }

        private void CargarDatos()
        {
            int? idEntrenador = EsEntrenador ? ObtenerIdEmpleado() : null;
            Expedientes = _logicaExpediente.Consultar(FiltroCliente, FiltroTipoSangre, idEntrenador);
            CatalogoCondiciones = _logicaExpediente.CatalogoCondiciones();
            Socios = _logicaCliente.Consultar();
            SociosConExpediente = _logicaExpediente.Consultar().ConvertAll(e => e.IdCliente);

            if (EsEntrenador)
            {
                var permitidos = _logicaExpediente.Consultar(null, null, idEntrenador);
                var idsSocios = permitidos.ConvertAll(e => e.IdCliente);
                foreach (DataRow fila in Socios.Select())
                {
                    if (!idsSocios.Contains(Convert.ToInt32(fila["IdCliente"])))
                        Socios.Rows.Remove(fila);
                }
                if (ExpedienteDetalle.HasValue && !permitidos.Exists(e => e.IdExpediente == ExpedienteDetalle.Value))
                    ExpedienteDetalle = null;
            }

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

        private int ObtenerIdEmpleado()
        {
            var idClaim = User.FindFirst("IdEmpleado")?.Value;
            return int.TryParse(idClaim, out int id) ? id : 0;
        }
    }
}
