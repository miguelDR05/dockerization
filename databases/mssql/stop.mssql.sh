#!/bin/bash
cd "$(dirname "$0")"
docker compose down

# Make executable with:
# ? chmod +x ~/dev/mssql/stop-mssql.sh