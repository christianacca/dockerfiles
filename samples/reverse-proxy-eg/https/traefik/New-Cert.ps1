#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot

# setup directory to bind mount into container
Remove-Item certs -Force -Confirm:$false -Recurse -EA SilentlyContinue
New-Item certs -ItemType Directory -Force

# Generate ssl cert
wsl openssl req -config test-app.config -new -x509 -sha256 -newkey rsa:2048 -nodes `
    -keyout test-app.key -days 3650 -out test-app.crt `
    -passin pass:password1234
wsl openssl pkcs12 -export -out test-app.pfx -inkey test-app.key -in test-app.crt `
    -password pass:password1234

# install as a trusted root cert (so browser doesn't issue security warnings)
$certPwd = ConvertTo-SecureString -String password1234 -Force -AsPlainText
Get-ChildItem test-app.pfx | 
    Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\Root -Password $certPwd -Confirm:$false
Remove-Item test-app.pfx

# Move crt and pfx file into certs folder
Move-Item test-app.key certs\
Move-Item test-app.crt certs\