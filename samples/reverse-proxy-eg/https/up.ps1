#Requires -RunAsAdministrator

# create locals certs and start traefik
Push-Location $PSScriptRoot\traefik
if (-not(Test-Path certs-trust)) {
    .\New-Cert.ps1
}
docker-compose up -d
Pop-Location

# start app
Push-Location $PSScriptRoot\app
docker-compose up -d
Pop-Location