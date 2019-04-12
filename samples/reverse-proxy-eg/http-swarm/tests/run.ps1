# . ../up.ps1
# Start-Sleep -Seconds 10
docker ps -f name=app_whoami  --format '{{.Names}}' | ForEach-Object {
    $taskIdx = $_.Split('.')[1]
    Set-Item "Env:\APP_CONTAINER_$taskIdx" -Value $_
}
docker ps -f name=traefik_proxy  --format '{{.Names}}' | ForEach-Object {
    $taskIdx = $_.Split('.')[1]
    Set-Item "Env:\TRAEFIK_CONTAINER_$taskIdx" -Value $_
}
docker-compose -f $PSScriptRoot/server-monitor-compose.yml -p server-monitor up -d
Start-Sleep -Seconds 5
docker-compose -f $PSScriptRoot/client-compose.yml -p client up --abort-on-container-exit --exit-code-from whoami-client
docker-compose -f $PSScriptRoot/server-monitor-compose.yml -p server-monitor down -v
docker-compose -f $PSScriptRoot/client-compose.yml -p client down -v
# . ../down.ps1