FROM eclipse-temurin:25-jre

LABEL org.opencontainers.image.title="Hytale Server"
LABEL org.opencontainers.image.description="Docker image to automatically download and run a Hytale server."
LABEL org.opencontainers.image.source="https://github.com/Luke100000/hytale-server"
LABEL org.opencontainers.image.documentation="https://github.com/Luke100000/hytale-server#readme"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.vendor="Luke100000"
LABEL org.opencontainers.image.authors="Luke100000"

RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

VOLUME ["/data"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
