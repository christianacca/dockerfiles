$env:TRAEFIK_STACK = 'traefik'
docker stack deploy -c $PSScriptRoot\traefik\docker-compose.yml $env:TRAEFIK_STACK
Write-Host "Waiting for $env:TRAEFIK_STACK stack to deploy"
Start-Sleep -Seconds 5
docker stack deploy -c $PSScriptRoot\app\docker-compose.yml app

# now browse to:
# * http://traefik.docker.localhost:81/
#   * username: docker
#   * password: Pn7-x6C@4xvP9,g
# * http://whoami.docker.localhost:81/