docker-compose -f $PSScriptRoot\traefik\docker-compose.yml up -d
Write-Host "Waiting for traefik stack to deploy"
Start-Sleep -Seconds 5
docker-compose -f $PSScriptRoot\app\docker-compose.yml up -d