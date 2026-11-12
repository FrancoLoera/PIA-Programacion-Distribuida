using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Entidades;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.Clientes
{
    [Authorize(Roles = "Administrador,Recepcionista")]
    public class IndexModel : PageModel
    {
        private readonly logicaCliente _logica;

        public IndexModel(logicaCliente logica)
        {
            _logica = logica;
        }

        [BindProperty]
        public bdCliente Cliente { get; set; } = new bdCliente();

        [BindProperty(SupportsGet = true)]
        public string? Buscar { get; set; }

        [BindProperty(SupportsGet = true)]
        public short? FiltroSucursal { get; set; }

        [BindProperty(SupportsGet = true)]
        public byte? FiltroEstatus { get; set; }

        public DataTable Clientes { get; set; } = new DataTable();
        public List<bdSucursal> Sucursales { get; set; } = new List<bdSucursal>();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            AjustarSucursalSiEsRecepcionista();
            CargarDatos();
        }

        public void OnGetEditar(int id)
        {
            Cliente = _logica.Obtener(id) ?? new bdCliente();
            AjustarSucursalSiEsRecepcionista();
            CargarDatos();
        }

        public void OnPostGuardar()
        {
            AjustarSucursalSiEsRecepcionista();

            if (!ModelState.IsValid)
            {
                TipoMensaje = "warning";
                Mensaje = "Por favor verifica los campos obligatorios del formulario.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logica.Guardar(Cliente, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            if (r.TipoMensaje == "success")
            {
                ModelState.Clear();
                Cliente = new bdCliente();
            }

            CargarDatos();
        }

        public void OnPostBaja(int id)
        {
            int idUsuario = ObtenerIdUsuario();
            var r = _logica.DarDeBaja(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            AjustarSucursalSiEsRecepcionista();
            CargarDatos();
        }

        public void OnPostReactivar(int id)
        {
            int idUsuario = ObtenerIdUsuario();
            var r = _logica.Reactivar(id, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;
            AjustarSucursalSiEsRecepcionista();
            CargarDatos();
        }

        private void CargarDatos()
        {
            Sucursales = _logica.ListarSucursalesActivas();
            Clientes = _logica.Consultar(Buscar, FiltroSucursal, FiltroEstatus);
        }

        private void AjustarSucursalSiEsRecepcionista()
        {
            // Regla 3: Recepcionista tiene permisos limitados a su sucursal
            if (User.IsInRole("Recepcionista"))
            {
                var idSucursalClaim = User.FindFirst("IdSucursal")?.Value;
                if (short.TryParse(idSucursalClaim, out short idSuc))
                {
                    FiltroSucursal = idSuc;
                    if (Cliente.IdCliente == 0)
                    {
                        Cliente.IdSucursal = idSuc;
                    }
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
