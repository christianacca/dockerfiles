using System.Net;
using Microsoft.AspNetCore.Mvc;

namespace server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WhoAmIController : ControllerBase
    {
        [HttpGet]
        public object Get() => new 
        {
            Host = Dns.GetHostName(),
            RequestHeaders = Request.Headers
        };
    }
}
