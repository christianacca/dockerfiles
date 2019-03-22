FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY server.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release -o /app --no-restore

FROM build AS publish
RUN dotnet publish -c Release -o /app --no-build

FROM base AS final
WORKDIR /app
ENTRYPOINT ["dotnet", "server.dll"]
COPY --from=publish /app .
