# Docker CLI

To test the Docker API from inside a Windows container it sometimes is useful to have the Docker CLI.

Especially for Windows Server 1709 it's easy to access the Docker API of the host

```
docker run --rm -v //./pipe/docker_engine://./pipe/docker_engine -u ContainerAdministrator christianacca/docker-cli-windows docker version
```

**IMPORTANT**: 

This container image is a temporary stop gap until [this issue](https://github.com/StefanScherer/dockerfiles-windows/tree/master/golang-issue-21867) is fixed

Once resolve, this image will no longer be maintained and you should use [stefanscherer/docker-cli-windows](https://hub.docker.com/r/stefanscherer/docker-cli-windows/) instead