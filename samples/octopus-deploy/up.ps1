[CmdletBinding()]
param(
    [SecureString] $DatabasePassword,
    [string] $DatabaseDockerImage = 'christianacca/mssql-server-windows-express:2017-latest-Latin1_General_CI_AS',
    [string] $OctopusVersion = '2018.12.1-1803',
    [string] $OctopusTentacleVersion = '3.22.1-1803',
    [pscredential] $OctopusCredential
)

$plainTextPassword = if ($DatabasePassword) {
    ConvertFrom-SecureString -$DatabasePassword
}
else {
    'SuperStrongPassword!23'
}
$env:SA_PASSWORD = $plainTextPassword
$env:SQL_IMAGE = $DatabaseDockerImage

if (!$OctopusCredential) {
    $pswd = ConvertTo-SecureString 'Passw0rd123' -AsPlainText -Force
    $OctopusCredential = [PsCredential]::new("admin", $pswd)
}
$env:OCTOPUS_ADMIN_USERNAME = $OctopusCredential.UserName
$env:OCTOPUS_ADMIN_PASSWORD = $OctopusCredential.GetNetworkCredential().Password
$env:OCTOPUS_VERSION = $OctopusVersion
$env:TENTACLE_VERSION = $OctopusTentacleVersion

$volumeRootPath = "$PSScriptRoot/volumes"
if (-not(Test-Path $volumeRootPath)) {
    & {
        New-Item $volumeRootPath/server/import -ItemType Directory -Force
        New-Item $volumeRootPath/server/repository -ItemType Directory -Force
        New-Item $volumeRootPath/server/artifacts -ItemType Directory -Force
        New-Item $volumeRootPath/server/tasklogs -ItemType Directory -Force
        New-Item $volumeRootPath/server/masterkey -ItemType Directory -Force
        New-Item $volumeRootPath/server/serverlogs -ItemType Directory -Force
        New-Item $volumeRootPath/tentacle/applications -ItemType Directory -Force
        New-Item $volumeRootPath/tentacle/home -ItemType Directory -Force
    } | Out-Null
}

docker-compose up -d