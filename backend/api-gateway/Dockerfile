FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

COPY CMS.sln ./
COPY api-gateway/api-gateway.csproj ./api-gateway/
COPY api-gateway/ ./api-gateway/

WORKDIR /app/api-gateway
RUN dotnet restore api-gateway.csproj
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/api-gateway/out .

EXPOSE 5000

ENTRYPOINT ["dotnet", "api-gateway.dll"]
