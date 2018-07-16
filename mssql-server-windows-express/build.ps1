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

    $usCollation = 'SQL_Latin1_General_CP1_CI_AS'
    $ukCollation = 'Latin1_General_CI_AS'
    $repo = 'christianacca/mssql-server-windows-express'
    $usTags = 'latest', $osVersion, $usCollation, "$usCollation-$osVersion"
    $latestImageTag = '{0}:{1}' -f $repo, ($usTags[0])
    
    exec { docker build -t $latestImageTag --build-arg SQL_COLLATION=$usCollation . }
    foreach ($tag in ($usTags | Select-Object -Skip 1)) {
        exec { docker tag $latestImageTag $repo`:$tag }
    }
    
    $ukTags = $ukCollation, "$ukCollation-$osVersion"
    $latestUkImageTag = '{0}:{1}' -f $repo, $ukCollation
    exec { docker build -t $latestUkImageTag --build-arg SQL_COLLATION=$ukCollation . }
    foreach ($tag in ($ukTags | Select-Object -Skip 1)) {
        exec { docker tag $latestUkImageTag $repo`:$tag }
    }
    
    if ($Publish) {
        foreach ($tag in $usTags) {
            exec { docker push $repo`:$tag }
        }
    }
}