param(
    [switch] $Publish
)

begin {
    $ErrorActionPreference = 'Stop'

    function exec {
        param([scriptblock] $Command)

        & $Command
        if ($LASTEXITCODE -ne 0) {
            throw "Command failed with exit code $LASTEXITCODE"
        }
    }
}
process {

    $osVersion = '1803'
    $sqlVersion = '2017'
    $sqlRelease = 'GA'
    $release = @(
        @{ Name = 'GA';   DownloadUrl = 'https://go.microsoft.com/fwlink/?linkid=829176'}
        @{ Name = 'CU12'; DownloadUrl = 'https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SQLEXPR_x64_ENU.exe'}
    )
    $repo = 'christianacca/mssql-server-windows-express'

    $usCollation = 'SQL_Latin1_General_CP1_CI_AS'
    $ukCollation = 'Latin1_General_CI_AS'
    $builds = @{
        $usCollation = @(
            'latest'
            $osVersion
            "$sqlVersion-latest"
            "$sqlVersion-$sqlRelease"
            "$usCollation-$osVersion" 
            "$sqlVersion-latest-$usCollation"
            "$sqlVersion-$sqlRelease-$usCollation"
            "$sqlVersion-$sqlRelease-$usCollation-$osVersion"
        )
        $ukCollation = @(
            "$ukCollation-$osVersion"
            "$sqlVersion-latest-$ukCollation"
            "$sqlVersion-$sqlRelease-$ukCollation"
            "$sqlVersion-$sqlRelease-$ukCollation-$osVersion"
        )
    }

    foreach ($collation in $builds.Keys) {
        $collationImageTag = '{0}:{1}' -f $repo, $collation
        exec { docker build -t $collationImageTag --build-arg SQL_COLLATION=$collation . }
        foreach ($tag in $builds[$collation]) {
            exec { docker tag $collationImageTag $repo`:$tag }
        }
    }

    if ($Publish) {
        foreach ($tag in ($builds.Keys + ($builds.Values | ForEach-Object { $_ }))) {
            exec { docker push $repo`:$tag }
        }
    }
}