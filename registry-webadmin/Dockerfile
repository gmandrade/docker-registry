FROM joxit/docker-registry-ui:static
COPY . /etc/docker/registry/
RUN apk upgrade --no-cache && \
    rm -f /etc/docker/registry/Dockerfile