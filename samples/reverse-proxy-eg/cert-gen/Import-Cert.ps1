function Import-Cert {
    [CmdletBinding()]
    param(
        [string] $Path = "$PSScriptRoot\out",
        [string] $Name = 'localhost',
        [string] $FriendlyName = "Self-signed $Name",
        [string] $ClearTextPassword = 'password1234',
        [ValidateSet('CurrentUser', 'LocalMachine')]
        [string] $Store = 'CurrentUser',
        [switch] $Force
    )
    begin {
        $callerEA = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {

            $cert = Get-ChildItem Cert:\$Store\Root\ | Where-Object  FriendlyName -eq $FriendlyName;
            if ($cert -and -not($Force)) {
                throw "Certificate exists; to overwrite please supply -Force switch"
            }

            $certPwd = ConvertTo-SecureString -String $ClearTextPassword -Force -AsPlainText
            $cert | Remove-Item
            Get-ChildItem $Path\$Name.pfx | 
                Import-PfxCertificate -CertStoreLocation Cert:\$Store\Root -Password $certPwd -Confirm:$false
        }
        catch {
            Write-Error -ErrorRecord $_ -EA $callerEA
        }
    }
}