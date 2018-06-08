param(
    [switch] $Publish
)

$dotNetVersion = '4.7.2'
$osVersion = '1803'

$tag = "$dotNetVersion-sdk-windowsservercore-$osVersion"
docker build -t christianacca/dotnet-framework:$tag .

if ($Publish) {
    docker push christianacca/dotnet-framework:$tag
}