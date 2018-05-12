param(
    [switch] $Publish
)

$dotNetVersion = '4.7.1'
docker build -t christianacca/dotnet-framework:$dotNetVersion-sdk .

if ($Publish) {
    docker push christianacca/dotnet-framework:$dotNetVersion-sdk
}