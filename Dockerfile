# Minimal Xray (VLESS + WebSocket) image for Cloady.
# - Official Xray binary from github.com/XTLS/Xray-core releases.
# - EXPOSE 8080 so Cloady detects the service port (no EXPOSE => worker, ingress 404).
# - UUID and WS_PATH come from environment variables at runtime.
#   No secrets are stored in this repo or in the built image.
FROM alpine:latest

RUN apk add --no-cache ca-certificates wget unzip && \
    wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ xray && \
    chmod +x /usr/local/bin/xray && \
    rm -f /tmp/xray.zip && \
    apk del wget unzip

EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
