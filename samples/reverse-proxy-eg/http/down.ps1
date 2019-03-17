Write-Host "Removing app stack"
docker-compose -f $PSScriptRoot\app\docker-compose.yml down
Write-Host "Removing traefik stack"
docker-compose -f $PSScriptRoot\traefik\docker-compose.yml down