#!/bin/bash
cd "$(dirname "$0")"
docker compose up -d

# Make executable with:
# ? chmod +x ~/dev/mssql/start-mssql.sh
