#Requires -RunAsAdministrator

$appStack = 'app'
Write-Host "Removing $appStack stack"
docker stack rm app

Write-Host "Waiting for $appStack stack to be removed"
Start-Sleep -Seconds 5

$traefikStack = 'traefik'
Write-Host "Removing $traefikStack stack"
docker stack rm $traefikStack

Write-Host "Waiting for $traefikStack stack to be removed"
Start-Sleep -Seconds 5

# remove certs
Get-ChildItem Cert:\LocalMachine\Root\ | Where-Object  { $_.GetName() -like '*docker.localhost*' } | Remove-Item
Remove-Item $PSScriptRoot\traefik\certs -Force -Confirm:$false -Recurse