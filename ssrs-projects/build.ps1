param(
    [switch] $Publish
)

$version = '1.21'
docker build -t christianacca/ssrs-projects:$version .

if ($Publish) {
    docker push christianacca/ssrs-projects:$version
    docker push christianacca/ssrs-projects:latest
}