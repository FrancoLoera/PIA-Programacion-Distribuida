using System;
using System.Data;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages.ControlAcceso
{
    [Authorize(Roles = "Administrador,Recepcionista")]
    public class IndexModel : PageModel
    {
        private readonly logicaControlAcceso _logicaControlAcceso;
        private readonly logicaCliente _logicaCliente;
        private readonly logicaSucursal _logicaSucursal;

        public IndexModel(logicaControlAcceso logicaControlAcceso, logicaCliente logicaCliente, logicaSucursal logicaSucursal)
        {
            _logicaControlAcceso = logicaControlAcceso;
            _logicaCliente = logicaCliente;
            _logicaSucursal = logicaSucursal;
        }

        [BindProperty]
        public int IdClienteAcceso { get; set; }

        [BindProperty]
        public short IdSucursalAcceso { get; set; }

        [BindProperty(SupportsGet = true)]
        public int? FiltroCliente { get; set; }

        [BindProperty(SupportsGet = true)]
        public short? FiltroSucursal { get; set; }

        [BindProperty(SupportsGet = true)]
        public DateTime? FiltroFecha { get; set; }

        public DataTable Accesos { get; set; } = new DataTable();
        public DataTable Socios { get; set; } = new DataTable();
        public DataTable Sucursales { get; set; } = new DataTable();

        public string Mensaje { get; set; } = "";
        public string TipoMensaje { get; set; } = "";

        public void OnGet()
        {
            AsignarSucursalPorDefecto();
            CargarDatos();
        }

        public void OnPostEntrada()
        {
            if (IdClienteAcceso <= 0 || IdSucursalAcceso <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Selecciona un socio y una sucursal para registrar el acceso.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaControlAcceso.RegistrarEntrada(IdClienteAcceso, IdSucursalAcceso, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            CargarDatos();
        }

        public void OnPostSalida(int idCliente)
        {
            if (idCliente <= 0)
            {
                idCliente = IdClienteAcceso;
            }

            if (idCliente <= 0)
            {
                TipoMensaje = "warning";
                Mensaje = "Selecciona un socio para registrar su salida.";
                CargarDatos();
                return;
            }

            int idUsuario = ObtenerIdUsuario();
            var r = _logicaControlAcceso.RegistrarSalida(idCliente, idUsuario);
            Mensaje = r.Mensaje;
            TipoMensaje = r.TipoMensaje;

            CargarDatos();
        }

        private void AsignarSucursalPorDefecto()
        {
            if (IdSucursalAcceso == 0)
            {
                var sucClaim = User.FindFirst("IdSucursal")?.Value;
                if (short.TryParse(sucClaim, out short idSuc) && idSuc > 0)
                {
                    IdSucursalAcceso = idSuc;
                    if (!FiltroSucursal.HasValue && !User.IsInRole("Administrador"))
                    {
                        FiltroSucursal = idSuc;
                    }
                }
            }
        }

        private void CargarDatos()
        {
            DateTime? fechaIni = null;
            DateTime? fechaFin = null;

            if (FiltroFecha.HasValue)
            {
                fechaIni = FiltroFecha.Value.Date;
                fechaFin = FiltroFecha.Value.Date.AddDays(1).AddTicks(-1);
            }

            Accesos = _logicaControlAcceso.Consultar(FiltroCliente, FiltroSucursal, fechaIni, fechaFin);
            Socios = _logicaCliente.Consultar(null, null, 1); // Socios activos
            Sucursales = _logicaSucursal.Consultar();
        }

        private int ObtenerIdUsuario()
        {
            var idClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.TryParse(idClaim, out int id) ? id : 1;
        }
    }
}
