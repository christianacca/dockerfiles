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
    $repo = 'christianacca/mssql-server-windows-express'

    $usCollation = 'SQL_Latin1_General_CP1_CI_AS'
    $ukCollation = 'Latin1_General_CI_AS'
    $builds = @{
        $usCollation = 'latest', $osVersion, "$usCollation-$osVersion"
        $ukCollation = "$ukCollation-$osVersion"
    }

    foreach ($collation in $builds.Keys) {
        $collationImageTag = '{0}:{1}' -f $repo, $collation
        exec { docker build -t $collationImageTag --build-arg SQL_COLLATION=$collation . }
        foreach ($tag in $builds[$collation]) {
            exec { docker tag $collationImageTag $repo`:$tag }
        }
    }

    if ($Publish) {
        foreach ($tag in ($builds.Keys + $builds.Values)) {
            exec { docker push $repo`:$tag }
        }
    }
}