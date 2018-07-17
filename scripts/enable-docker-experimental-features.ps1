Write-Host "Activating experimental features"
$daemonJson = "$env:ProgramData\docker\config\daemon.json"
$config = [PsCustomObject]@{}
if (Test-Path $daemonJson) {
    $config = Get-Content $daemonJson -Raw | ConvertFrom-Json
}
$config = $config | Add-Member(@{ experimental = $true }) -Force -PassThru
$config | ConvertTo-Json | Set-Content $daemonJson -Encoding Ascii