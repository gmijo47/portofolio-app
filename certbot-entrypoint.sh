#!/bin/sh
set -e

DOMAIN="galic.dev"
LIVE="/etc/letsencrypt/live/$DOMAIN"
WEBROOT="/var/www/certbot"
EMAIL="gmijo47@gmail.com"
DUMMY_MARKER="$LIVE/.dummy"

# Wait for nginx to finish starting
sleep 8

# ── Clean up any broken/leftover renewal configs ──────────────────
# These appear if a previous run failed mid-way (e.g. www DNS error)
for conf in /etc/letsencrypt/renewal/*.conf; do
    [ -f "$conf" ] || continue
    if ! grep -q "^cert = " "$conf" 2>/dev/null; then
        echo "[certbot] Removing broken renewal config: $conf"
        rm -f "$conf"
    fi
done
# Remove numbered duplicate dirs (galic.dev-0001 etc.)
for d in /etc/letsencrypt/live/${DOMAIN}-[0-9]*; do
    [ -d "$d" ] && rm -rf "$d" 2>/dev/null || true
done
for d in /etc/letsencrypt/archive/${DOMAIN}-[0-9]*; do
    [ -d "$d" ] && rm -rf "$d" 2>/dev/null || true
done

# ── Request real cert if only the dummy exists ────────────────────
if [ -f "$DUMMY_MARKER" ] || [ ! -f "$LIVE/fullchain.pem" ]; then
    echo "[certbot] Requesting Let's Encrypt certificate for $DOMAIN..."
    certbot certonly \
        --webroot -w "$WEBROOT" \
        --email "$EMAIL" \
        --agree-tos --no-eff-email \
        --keep-until-expiring \
        -d "$DOMAIN"
    rm -f "$DUMMY_MARKER"
    echo "[certbot] Certificate obtained. Nginx will reload shortly."
fi

# ── Renewal loop — runs every 12 hours ───────────────────────────
echo "[certbot] Starting renewal loop..."
trap exit TERM
while :; do
    certbot renew --quiet --webroot -w "$WEBROOT" || true
    sleep 12h & wait $!
done
