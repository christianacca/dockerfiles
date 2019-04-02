# httpclient-test

.net core console application used to make http request using `HttpClient` created via `HttpClientFactory`

## Supported settings

See [HttpRunnerSettings.cs](src/HttpRunnerSettings.cs) for an explanation of each setting that can be
supplied

See [appsttings.json](src/appsttings.json) `HttpRunner` for the default values for these settings.

To override these defaults you can use:
* docker config (swarm mode only) to supply an appsettings.json or appsettings-overrides.json file
* docker volume to supply an appsettings.json or appsettings-overrides.json file
* docker environment variable. See [docker-compose.yml](docker-compose.yml) for an example

## Build / Publish

* Build only: `./build.ps1`
* Build + publish: `./build.ps1 -Version 'latest',$Version -Publish -Credential christianacca`
    * where `$Version` is used to tag the image to build and publish