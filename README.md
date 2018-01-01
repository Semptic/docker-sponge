# Example usage

To start a minecraft container use:
```bash
docker run -v /tmp/mc:/minecraft -e EULA=true -e MC_VERSION=1.10.2 -e FORGE_VERSION=12.18.3 -e FORGE_BUILD=2555 -e SPONGE_API_VERSION=8.0.0 -e SPONGE_BUILD=2814 -e JAVA_OPTS="-Xms1G -Xmx2G -XX:+UseG1GC -server" semptic/minecraft-sponge
```
Create a volume for the mincraft data. Target folder is `/minecraft`. For example to mount a local folder: `-v /host/directory:/minecraft`.

## Configuration

### Environment Variables

#### Setup Variables

Those settings are only used in the first start

 * Minecraft version: MC_VERSION (e.g.: `-e MC_VERSION=1.10.2`)
 * Forge version: FORGE_VERSION (e.g.: `-e FORGE_VERSION=12.18.3`)
 * Forge build id: FORGE_BUILD (e.g.: `-e FORGE_BUILD=2254`)
 * Sponge api Version: SPONGE_API_VERSION (e.g: `-e SPONGE_API_VERSION=5.2.0`)
 * Sponge build id: SPONGE_BUILD (e.g: `-e SPONGE_BUILD=2234`)
 * Accept eula: EULA (e.g: `-e EULA=true`)

#### Java options

 * JAVA_OPTS (e.g.: `-e JAVA_OPTS="-Xms1G -Xmx2G -XX:+UseG1GC -server"`)






