FROM node:alpine

# ARG MESHCENTRAL2_VERSION="0.6.43"

# Environment Variables
ENV MARIADB_HOST=
ENV MARIADB_PORT=
ENV MARIADB_DATABASE=
ENV MARIADB_USER=
ENV MARIADB_PASS=
ENV DB_ENCRYPT_KEY=
ENV AGENT_PORT=
ENV HOSTNAME=



WORKDIR /meshcentral
ENV NODE_ENV=production
RUN apk update

# Generic pre-requisites for all maintained alpine images
# sudo             used to elevate a startup script for fixing file permissions
# libcap           used to allow binaries to bind to lower ports as non root 
RUN apk add --no-cache sudo libcap

# pre-requisites for meshcentral
# mariadb-common mariadb-client   used if a mongodb installation is used
# jo               used to craft the initial settings.json file
# jq               json parser, can be used to filter json files
RUN apk add --no-cache jo jq

# Add the ability to set file permissions to the non-privileged user
RUN echo "ALL ALL=NOPASSWD: /bin/chown -R 1000\:1000 /meshcentral" >> /etc/sudoers


# RUN npm install meshcentral@${MESHCENTRAL2_VERSION}
RUN npm install mariadb meshcentral
RUN npm install --no-optional --save archiver otplib image-size node-rdpjs-2 archiver-zip-encrypted

# set the meshcentral directory permissions to the node user
RUN /bin/chown -R 1000:1000 /meshcentral

# Allow node to bind to lower ports, even if not running as root
RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/node

COPY startup.sh startup.sh

# Volumes
### This is the primary volume for configuration files
VOLUME /meshcentral/meshcentral-data
### This is the primary volume for uploaded data
VOLUME /meshcentral/meshcentral-files
### This is the primary volume for database backups
VOLUME /meshcentral/meshcentral-backup

# We are exposing two ports: 80/443 for the web management interface. Optionally we can also (in config.json)
# expose the intel AMT port (4433) and an agent port (defaults to 8800, can be whatever)
EXPOSE 80 443 4443

USER node
WORKDIR /meshcentral

# ENTRYPOINT node "./node_modules/meshcentral"
ENTRYPOINT /bin/sh ./startup.sh
