FROM alpine:3.14 as builder

# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

# Pull in latest linkding docker image.
FROM neosmemo/memos:latest

# Copy Litestream from builder.
COPY --from=builder /usr/local/bin/litestream /usr/local/bin/litestream

# Copy Litestream configuration file.
COPY etc/litestream.yml /etc/litestream.yml

# Copy startup script and make it executable.
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

# Litestream spawns linkding's webserver as subprocess.
ENTRYPOINT ["sh" , "-c", "/scripts/run.sh"]
