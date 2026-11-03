#!/bin/sh
# Generate Xray VLESS+WS config from environment variables at container start.
# Required: UUID, WS_PATH. Optional: PORT (default 8080).
# No secrets are stored in this repo; they are injected via env at deploy time.
set -e
: "${UUID:?UUID env required}"
: "${WS_PATH:?WS_PATH env required}"
PORT="${PORT:-8080}"

cat > /etc/xray.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF

exec /usr/local/bin/xray run -config /etc/xray.json
