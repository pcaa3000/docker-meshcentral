# docker-meshcentral
Meshcentral Container
By default, the Docker will expose port 80 and 443, so change this within the
Dockerfile if necessary. When ready, simply use the Dockerfile to
build the image.

```sh
cd docker-meshcentral
docker build -t <youruser>/meshcentral-docker:latest .
```

Once done, run the Docker image and map the port to whatever you wish on
your host. In this example, we simply map port 8081 and 8443 of the host to
port 80 and 443 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8081:80 -p 8443:443 -p 8800:8800 -e AGENT_PORT=8800 -e HOSTNAME=remoteit.local --restart=always --name=meshcentral <youruser>/meshcentral-docker:latest
```

Execute mesh container in docker compose.
```sh
cd docker-meshcentral
docker compose build
docker compose up -d
```

Edit variale in _docker-compose.yaml_
```sh
    ...
    environment:
      - MONGODB_URL=mongodb://meshcentral-db:27017
      - MONGODB_NAME=meshcentral
      - DB_ENCRYPT_KEY=${DB_ENCRYPT_KEY}
      - AGENT_PORT=8800
      - HOSTNAME=remoteit.local
    ...
```

>Edit option meshcentral en _config.json_ in _container-data/meshcentral-data/_
To Add mail option review _smtp.json_ file.