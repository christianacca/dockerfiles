param(
    [switch] $Publish
)

$dotNetVersion = '4.7.2'
$osVersion = '1803'

$imageName = 'christianacca/dotnet-framework'
$tags = 'sdk', "$dotNetVersion-sdk", "$dotNetVersion-sdk-windowsservercore-$osVersion"
$latestImageTag = '{0}:{1}' -f $imageName, ($tags[0])

docker build -t $latestImageTag .
foreach ($tag in ($tags | Select-Object -Skip 1)) {
    docker tag $latestImageTag $imageName`:$tag
}

if ($Publish) {
    foreach ($tag in $tags) {
        docker push $imageName`:$tag
    }
}