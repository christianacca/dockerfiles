# .Net Framework Sdk image

Fork of official [dockerfile](https://github.com/Microsoft/dotnet-framework-docker/blob/master/4.7.1-windowsservercore-1709/sdk/Dockerfile)

Workaround:
* official dockerfile does not support building / publishing ASP.Net (track [PR89](https://github.com/Microsoft/dotnet-framework-docker/pull/89))
* offical dockerfile does not .NET 4.7.1 SDK and therefore is missing tools such as AL.exe (track [PR121](https://github.com/Microsoft/dotnet-framework-docker/pull/121))