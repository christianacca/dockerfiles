#Requires -RunAsAdministrator

function New-Cert {
    [CmdletBinding()]
    param(
        [string] $Path = "$PSScriptRoot\out",
        [switch] $Trust
    )
    begin {
        $callerEA = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        $tmpPath = "$env:TEMP\cert-gen"
    }
    process {
        try {
            # Generate ssl cert
            # For more information on how all this works see:
            # * https://medium.com/the-new-control-plane/generating-self-signed-certificates-on-windows-7812a600c2d8
            # * https://knowledge.digicert.com/solution/SO26630.html

            # prepare output directory
            if (Test-Path (Join-Path $Path '\*')) {
                throw "$Path is not empty"
            }
            New-Item $Path -ItemType Directory -Force

            # prepare temporary directory
            Remove-Item $tmpPath -Force -Confirm:$false -Recurse -EA SilentlyContinue
            New-Item $tmpPath -ItemType Directory -Force
            

            try {
                Copy-Item $PSScriptRoot\docker.localhost.config $tmpPath

                Push-Location $tmpPath
                wsl openssl req -config docker.localhost.config -new -x509 -sha256 -newkey rsa:2048 -nodes `
                    -keyout docker.localhost.key -days 3650 -out docker.localhost.crt `
                    -passin pass:password1234
                Pop-Location
    
                # install as a trusted root cert (so browser doesn't issue security warnings)
                if ($Trust) {
                    Push-Location $tmpPath
                    wsl openssl pkcs12 -export -out docker.localhost.pfx -inkey docker.localhost.key -in docker.localhost.crt `
                        -password pass:password1234
                    Pop-Location
                    $certPwd = ConvertTo-SecureString -String password1234 -Force -AsPlainText
                    Get-ChildItem $tmpPath\docker.localhost.pfx | 
                        Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\Root -Password $certPwd -Confirm:$false
                    Remove-Item $tmpPath\docker.localhost.pfx
                }
    
                # Move crt and key file into output folder
                Move-Item $tmpPath\docker.localhost.key $Path
                Move-Item $tmpPath\docker.localhost.crt $Path        
            }
            finally {
                Remove-Item $tmpPath -Force -Confirm:$false -Recurse -EA SilentlyContinue
            }
            
                    }
        catch {
            Write-Error -ErrorRecord $_ -EA $callerEA
        }
    }
}