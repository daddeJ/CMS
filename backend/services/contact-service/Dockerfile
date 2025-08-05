# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy everything inside src/ (including shared-dll and AuthService.API project)
COPY ./src/ ./src/

# Restore and publish from the project
RUN dotnet restore ./src/API/ContactService.API.csproj
RUN dotnet publish ./src/API/ContactService.API.csproj -c Release -o out

# Use the runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

# Copy published output from build stage
COPY --from=build /app/out .

# Entry point to run the API
EXPOSE 5002

ENTRYPOINT ["dotnet", "ContactService.API.dll"]
