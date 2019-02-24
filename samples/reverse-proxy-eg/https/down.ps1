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
Get-ChildItem Cert:\LocalMachine\Root\ | Where-Object { $_.GetName() -eq 'CN=test-app' } | Remove-Item
Remove-Item $PSScriptRoot\traefik\certs -Force -Confirm:$false -Recurse -EA SilentlyContinue
Remove-Item $PSScriptRoot\traefik\certs-trust -Force -Confirm:$false -Recurse -EA SilentlyContinue