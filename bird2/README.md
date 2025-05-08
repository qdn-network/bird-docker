# Bird2 Docker Image

Bird internet routing daemon in Docker image.

## Building image
You can build the docker image by running:
```
docker build --tag bird2 .
```

## Usage
Any **.sh** script that you have in a volume mounted at `/docker-entrypoint.d/` will be executed in container at start.
