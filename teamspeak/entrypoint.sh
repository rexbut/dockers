#!/bin/bash
set -e

# Create necessary directories in the data volume with proper permissions
mkdir -p /data/logs /data/files /data/crashdumps

# Ensure crashdumps directory is writable
chmod 755 /data/crashdumps 2>/dev/null || true

# Create SQLite config if it does not exist
if [ ! -f /data/ts3db_sqlite3.ini ]; then
    echo "[config]" > /data/ts3db_sqlite3.ini
    echo "database=/data/ts3server.sqlitedb" >> /data/ts3db_sqlite3.ini
fi

# Create symlink to SQLite config in the server directory
ln -sf /data/ts3db_sqlite3.ini /opt/teamspeak/ts3db_sqlite3.ini

# Create empty allowlist/denylist files if they don't exist
touch /data/query_ip_allowlist.txt 2>/dev/null || true
touch /data/query_ip_denylist.txt 2>/dev/null || true

# Change to server directory
cd /opt/teamspeak

# Export BOX64_LD_LIBRARY_PATH if not already set
export BOX64_LD_LIBRARY_PATH="${BOX64_LD_LIBRARY_PATH:-/opt/teamspeak:/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu}"

# Execute TeamSpeak server via Box64
exec box64 ./ts3server \
    logpath=/data/logs \
    dbsqlpath=sql/ \
    licensepath=/data \
    query_ip_allowlist=/data/query_ip_allowlist.txt \
    query_ip_denylist=/data/query_ip_denylist.txt \
    crashdumps_path=/data/crashdumps \
    "$@"
