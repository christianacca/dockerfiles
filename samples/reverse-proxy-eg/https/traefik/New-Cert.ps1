#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

# setup directories
Remove-Item $PSScriptRoot\certs -Force -Confirm:$false -Recurse -EA SilentlyContinue
Remove-Item $PSScriptRoot\certs-trust -Force -Confirm:$false -Recurse -EA SilentlyContinue
New-Item $PSScriptRoot\certs -ItemType Directory
New-Item $PSScriptRoot\certs-trust -ItemType Directory

# Generate a test cert
$cert = New-SelfSignedCertificate -FriendlyName test-app -CertStoreLocation Cert:\LocalMachine\My -DnsName test-app
$certPwd = ConvertTo-SecureString -String password1234 -Force -AsPlainText
$path = 'Cert:\LocalMachine\My\' + $cert.thumbprint
Export-PfxCertificate -cert $path -FilePath $PSScriptRoot\certs-trust\test-app.pfx -Password $certPwd
# remove cert added to store by `New-SelfSignedCertificate` (we don't want it there)
Remove-Item $path
# trust certificate (so browser doesn't issue security warnings)
Get-ChildItem $PSScriptRoot\certs-trust\test-app.pfx | 
    Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\Root -Password $certPwd -Confirm:$false

# Export crt and key file from pfx file
Push-Location $PSScriptRoot\certs-trust\
wsl openssl pkcs12 -in test-app.pfx -nocerts -out test-app.key -nodes -password pass:password1234
wsl openssl pkcs12 -in test-app.pfx -nokeys -out test-app.crt -password pass:password1234
Pop-Location

# Move crt and pfx file into certs folder
Move-Item $PSScriptRoot\certs-trust\test-app.key $PSScriptRoot\certs\
Move-Item $PSScriptRoot\certs-trust\test-app.crt $PSScriptRoot\certs\