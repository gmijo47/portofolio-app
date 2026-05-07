#!/bin/sh
set -e

DOMAIN="galic.dev"
LIVE="/etc/letsencrypt/live/$DOMAIN"
DUMMY_MARKER="$LIVE/.dummy"

# ── Create dummy self-signed cert if no real cert exists ──────────
if [ ! -f "$LIVE/fullchain.pem" ]; then
    echo "[nginx-start] No certificate found — generating temporary self-signed cert..."
    mkdir -p "$LIVE"
    openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
        -keyout "$LIVE/privkey.pem" \
        -out    "$LIVE/fullchain.pem" \
        -subj   '/CN=localhost' 2>/dev/null
    touch "$DUMMY_MARKER"
    echo "[nginx-start] Temporary cert ready. Nginx will reload once the real cert arrives."
fi

# ── Watch for real cert and reload nginx ──────────────────────────
if [ -f "$DUMMY_MARKER" ]; then
    (
        echo "[nginx-start] Waiting for real Let's Encrypt certificate..."
        while [ -f "$DUMMY_MARKER" ]; do sleep 5; done
        echo "[nginx-start] Real certificate detected — reloading nginx..."
        nginx -s reload
    ) &
fi

# ── Periodic reload every 12h to pick up renewed certs ───────────
(while true; do sleep 12h; nginx -s reload 2>/dev/null || true; done) &

exec nginx -g 'daemon off;'
