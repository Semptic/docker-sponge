FROM java:8-jre-alpine

RUN apk add --no-cache curl jq

RUN mkdir /mc
ADD launch.sh /mc/
ADD server.properties /mc/

RUN chmod +x /mc/launch.sh

VOLUME /minecraft
EXPOSE 25565

CMD "/mc/launch.sh"
