[CmdletBinding()]
param(
    [SecureString] $DatabasePassword,
    [string] $DatabaseDockerImage = 'christianacca/mssql-server-windows-express:2017-latest-Latin1_General_CI_AS',
    [string] $OctopusVersion = '2018.12.1-1803',
    [string] $OctopusTentacleVersion = '3.22.1-1803',
    [pscredential] $OctopusCredential,
    [switch] $SwarmDeploy
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

if ($SwarmDeploy) {
    docker stack deploy -c docker-compose.yml octo
} else {
    docker-compose up -d    
}