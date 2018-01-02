#!/bin/sh

set -e

SPONGE_DOWNLOAD_URL="https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/${SPONGE_VERSION}/spongeforge-${SPONGE_VERSION}.jar"

FORGE_DOWNLOAD_URL="http://files.minecraftforge.net/maven/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar"

SERVER="forge-${MC_VERSION}-${FORGE_VERSION}-universal.jar"
SPONGE="spongeforge-${SPONGE_VERSION}.jar"

if [ ! -f "/minecraft/${SERVER}" ]; then
    echo "Installing server, take a coffee"

    mkdir -p /tmp/mc

    cd /tmp/mc

    echo "Downloading forge ${FORGE_DOWNLOAD_URL}"
    curl -s "${FORGE_DOWNLOAD_URL}" -O

    cd /minecraft

    if [ "$EULA" != "" ]; then
        echo "# Generated via Docker on $(date)" > eula.txt
        echo "eula=$EULA" >> eula.txt
    fi

    java -jar "/tmp/mc/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar" --installServer

    mkdir -p /minecraft/mods

    cd /minecraft

    rm -r /tmp/mc
fi

if [ ! -f "/minecraft/mods/${SPONGE}" ]; then
    mkdir -p /tmp/mc

    cd /tmp/mc
    
    echo "Downloading sponge ${SPONGE_DOWNLOAD_URL}"
    curl -s "${SPONGE_DOWNLOAD_URL}" -O

    rm -f "/minecraft/mods/spongeforge-*.jar"

    mv "/tmp/mc/${SPONGE}" /minecraft/mods/

    cd /minecraft

    rm -r /tmp/mc
fi

cd /minecraft

echo "Starting minecraft"
java ${JAVA_OPTS} -jar "${SERVER}" --nogui
