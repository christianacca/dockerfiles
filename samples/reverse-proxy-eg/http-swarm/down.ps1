$appStack = 'app'
Write-Host "Removing $appStack stack"
docker stack rm app

Write-Host "Waiting for $appStack stack to be removed"
Start-Sleep -Seconds 15

$traefikStack = 'traefik'
Write-Host "Removing $traefikStack stack"
docker stack rm $traefikStack