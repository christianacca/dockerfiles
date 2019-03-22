using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Options;

namespace server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KestrelSettingsController : ControllerBase
    {
        public KestrelSettingsController(IOptions<KestrelServerOptions> settings) 
        {
            Settings = settings.Value;
        }

        private KestrelServerOptions Settings { get; }

        [HttpGet]
        public KestrelServerLimits Get() => Settings.Limits;
    }
}
