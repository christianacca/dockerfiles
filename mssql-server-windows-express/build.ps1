param(
    [switch] $Publish
)

$osVersion = '1803'

$repo = 'christianacca/mssql-server-windows-express'
$tags = 'latest', $osVersion
$latestImageTag = '{0}:{1}' -f $repo, ($tags[0])

docker build -t $latestImageTag .
foreach ($tag in ($tags | Select-Object -Skip 1)) {
    docker tag $latestImageTag $repo`:$tag
}

if ($Publish) {
    foreach ($tag in $tags) {
        docker push $repo`:$tag
    }
}