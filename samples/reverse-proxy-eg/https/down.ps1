#Requires -RunAsAdministrator

# stop app
Push-Location $PSScriptRoot\app
docker-compose down
Pop-Location

# stop traefik
Push-Location $PSScriptRoot\traefik
docker-compose down
Pop-Location

# remove certs
Get-ChildItem Cert:\LocalMachine\Root\ | Where-Object  FriendlyName -eq 'Self-signed docker.localhost' | Remove-Item
Remove-Item $PSScriptRoot\traefik\certs -Force -Confirm:$false -Recurse