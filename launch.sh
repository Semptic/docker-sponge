#!/bin/sh

set -e

SPONGE_VERSION="${MC_VERSION}-${FORGE_BUILD}-${SPONGE_API_VERSION}-BETA-${SPONGE_BUILD}"
SPONGE_DOWNLOAD_URL="https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/${SPONGE_VERSION}/spongeforge-${SPONGE_VERSION}.jar"

FORGE_DOWNLOAD_URL="http://files.minecraftforge.net/maven/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}.${FORGE_BUILD}/forge-${MC_VERSION}-${FORGE_VERSION}.${FORGE_BUILD}-installer.jar"

SERVER="forge-${MC_VERSION}-${FORGE_VERSION}.${FORGE_BUILD}-universal.jar"

if [ ! -f "/minecraft/${SERVER}" ]; then
    echo "Installing server, take a coffee"

    mkdir -p /tmp/mc

    cd /tmp/mc

    echo "Downloading sponge ${SPONGE_DOWNLOAD_URL}"
    curl -s "${SPONGE_DOWNLOAD_URL}" -O
    
    echo "Downloading forge ${FORGE_DOWNLOAD_URL}"
    curl -s "${FORGE_DOWNLOAD_URL}" -O

    cd /minecraft

    if [ "$EULA" != "" ]; then
        echo "# Generated via Docker on $(date)" > eula.txt
        echo "eula=$EULA" >> eula.txt
    fi

    java -jar "/tmp/mc/forge-${MC_VERSION}-${FORGE_VERSION}.${FORGE_BUILD}-installer.jar" --installServer

    mkdir -p mods

    mv "/tmp/mc/spongeforge-${SPONGE_VERSION}.jar" mods/

    rm -r /tmp/mc
fi

cd /minecraft

echo "Starting minecraft"
java ${JAVA_OPTS} -jar "${SERVER}" --nogui
