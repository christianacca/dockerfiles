using System.Linq;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Configuration;

namespace server
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args)
        {
            return WebHost.CreateDefaultBuilder(args)
                .UseKestrel((builderContext, options) => {
                    // Configuring Limits from appsettings.json is not supported.
                    // So we manually copy them from config.
                    // See https://github.com/aspnet/KestrelHttpServer/issues/2216
                    var kestrelOptions = builderContext.Configuration.GetSection("Kestrel").Get<KestrelServerOptions>();
                    foreach (var property in typeof(KestrelServerLimits).GetProperties().Where(p => p.CanWrite))
                    {
                        var value = property.GetValue(kestrelOptions.Limits);
                        property.SetValue(options.Limits, value);
                    }
                })
                .UseStartup<Startup>();
        }
    }
}
