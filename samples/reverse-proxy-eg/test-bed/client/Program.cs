using System;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace client
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var builder = new HostBuilder()
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    config.AddJsonFile("appsettings.json", optional: true);
                    config.AddEnvironmentVariables();

                    if (args != null)
                        config.AddCommandLine(args);
                })
                .ConfigureServices((hostContext, services) =>
                {
                    services.AddHttpClient();
                    services.Configure<TestRunnerSettings>(hostContext.Configuration.GetSection("TestRunner"));
                    services.AddHostedService<TestRunner>();
                })
                .ConfigureLogging((hostingContext, logging) =>
                {
                    logging.AddConfiguration(hostingContext.Configuration.GetSection("Logging"));
                    logging.AddConsole();
                });
            
            await builder.RunConsoleAsync();
        }
    }
}
