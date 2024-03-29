# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source
#
# copy csproj and restore as distinct layers
COPY *.csproj .
ADD server.crt /usr/local/share/ca-certificates/server.crt
RUN chmod 644 /usr/local/share/ca-certificates/server.crt && update-ca-certificates
RUN curl https://ipinfo.io
RUN curl https://api.nuget.org
RUN dotnet restore --use-current-runtime
#
# copy and publish app and libraries
COPY . .
RUN dotnet publish -c Release -o /app --use-current-runtime --self-contained false --no-restore
#
# final stage/image
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "dotnetapp.dll"]