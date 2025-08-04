#!/bin/bash

# Configuration
CONTAINER_NAME=cms-sqlserver
SA_PASSWORD=YourStrong@Passw0rd
SQL_FILE_PATH=/docker/sql/init.sql

echo "⏳ Waiting for SQL Server ($CONTAINER_NAME) to be available..."

# Wait for SQL Server to accept connections
until /opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "$SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1
do
  echo "🔄 Still waiting..."
  sleep 2
done

echo "✅ SQL Server is up. Running init.sql..."

# Run SQL file
/opt/mssql-tools/bin/sqlcmd -S sqlserver -U sa -P "$SA_PASSWORD" -i "$SQL_FILE_PATH"

echo "✅ init.sql executed successfully."
