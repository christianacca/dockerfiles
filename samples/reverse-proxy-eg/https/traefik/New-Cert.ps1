#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot

# setup directory to bind mount into container
Remove-Item certs -Force -Confirm:$false -Recurse -EA SilentlyContinue
New-Item certs -ItemType Directory -Force

# Generate ssl cert
# For more information on how all this works see:
# * https://medium.com/the-new-control-plane/generating-self-signed-certificates-on-windows-7812a600c2d8
# * https://knowledge.digicert.com/solution/SO26630.html
wsl openssl req -config docker.localhost.config -new -x509 -sha256 -newkey rsa:2048 -nodes `
    -keyout docker.localhost.key -days 3650 -out docker.localhost.crt `
    -passin pass:password1234
    wsl openssl pkcs12 -export -out docker.localhost.pfx -inkey docker.localhost.key -in docker.localhost.crt `
    -password pass:password1234

# install as a trusted root cert (so browser doesn't issue security warnings)
$certPwd = ConvertTo-SecureString -String password1234 -Force -AsPlainText
Get-ChildItem docker.localhost.pfx | 
    Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\Root -Password $certPwd -Confirm:$false
Remove-Item docker.localhost.pfx

# Move crt and pfx file into certs folder
Move-Item docker.localhost.key certs\
Move-Item docker.localhost.crt certs\