using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using PIA_Gimnasio.Logica;

namespace PIA_Gimnasio.Pages
{
    [AllowAnonymous]
    public class LoginModel : PageModel
    {
        private readonly logicaUsuario _logicaUsuario;

        public LoginModel(logicaUsuario logicaUsuario)
        {
            _logicaUsuario = logicaUsuario;
        }

        [BindProperty]
        public string NombreCuenta { get; set; } = "";

        [BindProperty]
        public string Contrasena { get; set; } = "";

        [BindProperty(SupportsGet = true)]
        public string? ReturnUrl { get; set; }

        public string Mensaje { get; set; } = "";

        public IActionResult OnGet()
        {
            if (User.Identity != null && User.Identity.IsAuthenticated)
            {
                return RedirectToPage("/Index");
            }

            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (string.IsNullOrWhiteSpace(NombreCuenta) || string.IsNullOrWhiteSpace(Contrasena))
            {
                Mensaje = "Ingresa tu usuario y contraseña.";
                return Page();
            }

            var usuario = _logicaUsuario.Autenticar(NombreCuenta, Contrasena, out string error);

            if (usuario == null)
            {
                Mensaje = error;
                return Page();
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, usuario.IdUsuario.ToString()),
                new Claim(ClaimTypes.Name, usuario.NombreCuenta),
                new Claim(ClaimTypes.Role, usuario.Rol),
                new Claim("IdEmpleado", usuario.IdEmpleado.ToString()),
                new Claim("NombreCompleto", usuario.NombreCompleto),
                new Claim("IdSucursal", usuario.IdSucursal.ToString()),
                new Claim("Sucursal", usuario.Sucursal ?? "")
            };

            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var authProperties = new AuthenticationProperties
            {
                IsPersistent = true
            };

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties
            );

            if (!string.IsNullOrEmpty(ReturnUrl) && Url.IsLocalUrl(ReturnUrl))
            {
                return LocalRedirect(ReturnUrl);
            }

            return RedirectToPage("/Index");
        }
    }
}
