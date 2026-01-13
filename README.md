# Docker Hytale Server

Script and docker to automatically download and run a Hytale server with sensible defaults and automatic backups.

## Environment Variables

Common settings:

- `MAX_MEMORY`: Maximum memory allocation for the server (default: `4G`).
- `INITIAL_MEMORY`: Initial memory allocation for the server (default: `MAX_MEMORY`).
- `ADDRESS`: The address the server will bind to (default: `0.0.0.0:5520`).
- `BACKUP_FREQUENCY`: Frequency of automatic backups in minutes (default: `480`).
- `BACKUP_RETENTION`: Number of backups to retain (default: `5`).

Or full override (will ignore common settings if set):

- `JAVA_OPTS`: Custom JVM options. Defaults to optimized JVM options for Hytale.
- `ARGS`: Custom arguments to pass to the server on startup. Defaults to recommended arguments for small servers.

## Run as script

```sh
chmod +x hytale-server.sh
export MAX_MEMORY=4G
./hytale-server.sh
```

## Run as docker container

Image is available on Docker Hub: [Luke100000/hytale-server](https://hub.docker.com/r/Luke100000/hytale-server).

Persistent data is stored in the `/data` folder.

```sh
docker run -v ./data:/data -p 5520:5520/udp -e MAX_MEMORY=4G Luke100000/hytale-server
```

## Authentication

Servers must be authenticated using device authentication:

1) First click on the device authentication link for the server downloader.
2) Run the Hytale server command `/auth login device`, authenticate, and optionally store the credentials with
   `/auth persistence Encrypted`.
