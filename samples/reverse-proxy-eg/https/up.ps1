#Requires -RunAsAdministrator

$scriptPath = Resolve-Path "$PSScriptRoot\..\cert-gen\New-Cert.ps1"
. $scriptPath

# create locals certs and start traefik
if (-not(Test-Path $PSScriptRoot\traefik\certs\*)) {
    New-Cert -Path $PSScriptRoot\traefik\certs -Name 'docker.localhost' -Trust -Store LocalMachine
}
docker-compose -f $PSScriptRoot\traefik\docker-compose.yml up -d

# start app
docker-compose -f $PSScriptRoot\app\docker-compose.yml up -d