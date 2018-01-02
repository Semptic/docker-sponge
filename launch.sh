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

    if [ ! -f "/minecraft/server.properties" ]; then
        export MOTD=$MOTD
        export RCON_PW=$RCON_PW

        envsubst "$MOTD:$RCONPW /mc/server.properties > /minecraft/server.properties
    fi

    java -jar "/tmp/mc/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar" --installServer

    mkdir -p /minecraft/mods

    cd /minecraft

    rm -r /tmp/mc
fi

if [ ${FORGE_VERSION} = "latest" ]; then
  curl -fsSL -o /tmp/forge.json http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json
  FORGE_VERSION=$(cat /tmp/forge.json | jq -r ".promos[\"$MC_VERSION-latest\"]")
else
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
fi

cd /minecraft

echo "Starting minecraft"
java ${JAVA_OPTS} -jar "${SERVER}" --nogui
