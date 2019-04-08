FROM mcr.microsoft.com/powershell:6.2.0-alpine-3.8
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /src
ENTRYPOINT [ "pwsh", "./split.ps1" ]
COPY split.ps1 .
