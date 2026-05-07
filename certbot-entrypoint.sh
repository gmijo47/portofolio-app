#!/bin/sh
set -e

DOMAIN="galic.dev"
LIVE="/etc/letsencrypt/live/$DOMAIN"
WEBROOT="/var/www/certbot"
EMAIL="gmijo47@gmail.com"
DUMMY_MARKER="$LIVE/.dummy"

# Wait a few seconds for nginx to finish starting
sleep 8

# ── Request real cert if only the dummy exists ────────────────────
if [ -f "$DUMMY_MARKER" ] || [ ! -f "$LIVE/chain.pem" ]; then
    echo "[certbot] Requesting Let's Encrypt certificate for $DOMAIN..."
    certbot certonly \
        --webroot -w "$WEBROOT" \
        --email "$EMAIL" \
        --agree-tos --no-eff-email \
        --force-renewal \
        -d "$DOMAIN" -d "www.$DOMAIN"
    # Remove dummy marker so nginx-start watcher triggers a reload
    rm -f "$DUMMY_MARKER"
    echo "[certbot] Certificate obtained. Nginx will reload shortly."
fi

# ── Renewal loop — runs every 12 hours ───────────────────────────
echo "[certbot] Starting renewal loop..."
trap exit TERM
while :; do
    certbot renew --quiet --webroot -w "$WEBROOT"
    sleep 12h & wait $!
done
