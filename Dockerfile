# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source


COPY . ./
RUN dotnet restore
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /source/ServiceGateway/iProofMOM/bin/ /app/
COPY --from=build /source/ServiceGateway/ProofMiddlewareBinaries/netstandard2.0/ /app/Release/
COPY --from=build /source/ServiceGateway/ProofMiddlewareBinaries/netstandard2.0/ /app/
COPY --from=build /source/ServiceGateway/iProofMOM/bin/iProofMOM.xml /app/Release/
WORKDIR /app/Release
ENTRYPOINT ["dotnet", "iProofMOM.dll"]