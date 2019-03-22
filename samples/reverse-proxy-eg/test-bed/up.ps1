docker ps -f name=test-bed_whoami  --format '{{.Names}}' | ForEach-Object {
    $taskIdx = $_.Split('.')[1]
    Set-Item "Env:\SEVER_CONTAINER_$taskIdx" -Value $_
}

docker stack deploy -c server-stack.yml test-bed
Start-Sleep -Seconds 5
docker-compose -f server-monitor-compose.yml -p server-monitor up -d
Start-Sleep -Seconds 5
docker-compose -f client-compose.yml -p client up -d
Start-Sleep -Seconds 60
docker-compose -f server-monitor-compose.yml -p server-monitor down
docker-compose -f client-compose.yml -p client down
docker stack rm test-bed