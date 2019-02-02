[CmdletBinding()]
param(
    [SecureString] $DatabasePassword,
    [string] $DatabaseVersion = '2017-latest-Latin1_General_CI_AS',
    [string] $OctopusVersion = '2019.1.2-1809',
    [string] $OctopusTentacleVersion = '4.0.0-1809',
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
$env:SQL_TAG = $DatabaseVersion

if (!$OctopusCredential) {
    $pswd = ConvertTo-SecureString 'Passw0rd123' -AsPlainText -Force
    $OctopusCredential = [PsCredential]::new("admin", $pswd)
}
$env:OCTOPUS_ADMIN_USERNAME = $OctopusCredential.UserName
$env:OCTOPUS_ADMIN_PASSWORD = $OctopusCredential.GetNetworkCredential().Password
$env:OCTOPUS_VERSION = $OctopusVersion
$env:TENTACLE_VERSION = $OctopusTentacleVersion

if ($SwarmDeploy) {
    docker stack deploy -c docker-compose-swarm.yml octo
} else {
    docker-compose up -d
}