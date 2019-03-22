using System;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace client
{
    public class TestRunner : BackgroundService
    {
        public TestRunner(IHttpClientFactory clientFactory, IOptions<TestRunnerSettings> settings, ILogger<TestRunner> logger)
        {
            ClientFactory = clientFactory;
            Logger = logger;
            Settings = settings.Value;
        }

        private IHttpClientFactory ClientFactory { get; }
        private ILogger<TestRunner> Logger { get; }
        private TestRunnerSettings Settings { get; }

        private async Task RunTest(CancellationToken cancellationToken)
        {
            using (var client = ClientFactory.CreateClient())
            {
                // client.DefaultRequestHeaders.ConnectionClose = true;

                Logger.LogInformation("Test started");
                // delay to allow our monitoring container to attach to network
                await Delay(TimeSpan.FromSeconds(5), cancellationToken);
                await MakeRequest(client, cancellationToken);
                await Delay(TimeSpan.FromSeconds(2), cancellationToken);
                await MakeRequest(client, cancellationToken);
                await Delay(TimeSpan.FromSeconds(30), cancellationToken);
                await MakeRequest(client, cancellationToken);
                Logger.LogInformation("Test done");
            }
        }

        private async Task Delay(TimeSpan delay, CancellationToken cancellationToken)
        {
            Logger.LogInformation("About to sleep for {delay}", delay);
            await Task.Delay(delay, cancellationToken);
            Logger.LogInformation("Resuming after sleep");
        }

        private async Task MakeRequest(HttpClient client, CancellationToken cancellationToken)
        {
            if (cancellationToken.IsCancellationRequested) return;

            var request = new HttpRequestMessage(HttpMethod.Get, Settings.Url);
            var response = await client.SendAsync(request, cancellationToken);
            var level = response.IsSuccessStatusCode ? LogLevel.Information : LogLevel.Warning;
            Logger.Log(level, response.ToString());
            Logger.Log(level, await response.Content.ReadAsStringAsync());
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            await RunTest(stoppingToken);
        }
    }
}