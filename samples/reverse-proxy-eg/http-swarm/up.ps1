$env:TRAEFIK_STACK = 'traefik'
docker stack deploy -c $PSScriptRoot\traefik\docker-compose.yml $env:TRAEFIK_STACK
Write-Host "Waiting for $env:TRAEFIK_STACK stack to deploy"
Start-Sleep -Seconds 5
docker stack deploy -c $PSScriptRoot\app\docker-compose.yml app