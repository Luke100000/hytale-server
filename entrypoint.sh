#!/bin/bash
set -e

mkdir -p data
cd data

: "${MAX_MEMORY:=4G}"
: "${ADDRESS:=0.0.0.0:5520}"
: "${BACKUP_FREQUENCY:=480}"
: "${BACKUP_MAX_COUNT:=5}"

# Default arguments when not overridden by `ARGS`
ARGS_DEFAULT="
--backup
--backup-frequency $BACKUP_FREQUENCY
--backup-max-count $BACKUP_MAX_COUNT
--backup-dir backups
--log INFO
--bind $ADDRESS
--assets Assets.zip
--accept-early-plugins
--disable-sentry
--disable-file-watcher
"

# Default Java options when not overridden by `JAVA_OPTS`
JAVA_OPTS_DEFAULT="
-Xms$MAX_MEMORY
-Xmx$MAX_MEMORY
-XX:+UseG1GC
-XX:MaxGCPauseMillis=150
-XX:+AlwaysPreTouch
-XX:G1HeapRegionSize=16M
-XX:G1ReservePercent=15
-XX:InitiatingHeapOccupancyPercent=20
-XX:+UseStringDeduplication
-XX:+PerfDisableSharedMem
-XX:ReservedCodeCacheSize=400M
"

JAVA_OPTS_FINAL="${JAVA_OPTS:-$JAVA_OPTS_DEFAULT}"
ARGS_FINAL="${ARGS:-$ARGS_DEFAULT}"

# Download downloader
FILE="hytale-downloader-linux-amd64"
ZIP="hytale-downloader.zip"
URL="https://downloader.hytale.com/hytale-downloader.zip"

if [ ! -f "$FILE" ]; then
    wget -O "$ZIP" "$URL"
    unzip -j "$ZIP" "$FILE"
    rm "$ZIP"
fi

# Download assets
./hytale-downloader-linux-amd64
VERSION=$(./hytale-downloader-linux-amd64 -print-version)
VERSION_FILE=".current-version"
if [[ ! -f $VERSION_FILE || $(cat $VERSION_FILE) != "$VERSION" ]]; then
    echo "New version detected: $VERSION. Downloading..."
    ./hytale-downloader-linux-amd64 -download-path game.zip
    unzip -o game.zip -d .
    echo "$VERSION" > $VERSION_FILE
    rm game.zip
else
    echo "Version $VERSION is up to date."
fi

# shellcheck disable=SC2086
exec java -XX:AOTCache="Server/HytaleServer.aot" $JAVA_OPTS_FINAL -jar "Server/HytaleServer.jar" $ARGS_FINAL
