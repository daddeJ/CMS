#!/bin/bash
# build-shared.sh

cd CMS

# Build shared library
echo "Building shared library..."
dotnet build ./shared/Shared.csproj -c Release -o ./shared-dll

# Copy DLL to services
echo "Copying shared DLL to services..."
cp -r ./shared-dll ./backend/services/contact-service/src/
cp -r ./shared-dll ./backend/services/auth-service/src/

echo "Shared library built and distributed!"
