[CmdletBinding()]
param(
    [switch] $SwarmDeploy
)

if ($SwarmDeploy) {
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml config | Out-String | docker stack deploy --compose-file - portainer
} else {
    docker-compose up -d
}