docker stack deploy -c ./app/docker-compose.yml no-proxy
Start-Sleep -Seconds 10
docker ps -f name=no-proxy_whoami  --format '{{.Names}}' | ForEach-Object {
    $taskIdx = $_.Split('.')[1]
    Set-Item "Env:\SERVER_CONTAINER_$taskIdx" -Value $_
}
docker-compose -f ./tests/server-monitor-compose.yml -p server-monitor up -d
Start-Sleep -Seconds 5
docker-compose -f ./tests/client-compose.yml -p client up --abort-on-container-exit --exit-code-from whoami-client
docker-compose -f ./tests/server-monitor-compose.yml -p server-monitor down -v
docker-compose -f ./tests/client-compose.yml -p client down -v
docker stack rm no-proxy