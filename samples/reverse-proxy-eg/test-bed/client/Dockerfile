FROM microsoft/dotnet:2.2-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY client.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release -o /app --no-restore

FROM build AS publish
RUN dotnet publish -c Release -o /app --no-build

FROM base AS final
WORKDIR /app
ENTRYPOINT ["dotnet", "client.dll"]
COPY --from=publish /app .
