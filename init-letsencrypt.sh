#!/bin/bash
# Run this ONCE on the server before `docker compose up -d`.
# It bootstraps the Let's Encrypt certificate so nginx can start.

set -e

DOMAIN="galic.dev"
DOMAINS="-d galic.dev -d www.galic.dev"
EMAIL="gmijo47@gmail.com"
WEBROOT="/var/www/certbot"

# ── 1. Create a dummy self-signed cert so nginx can start ──────────────────
echo "==> Creating dummy certificate for ${DOMAIN}..."

docker compose run --rm --entrypoint "sh -c ' \
  mkdir -p /etc/letsencrypt/live/${DOMAIN} && \
  openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
    -keyout /etc/letsencrypt/live/${DOMAIN}/privkey.pem \
    -out    /etc/letsencrypt/live/${DOMAIN}/fullchain.pem \
    -subj   \"/CN=localhost\" \
'" certbot

# ── 2. Start nginx with the dummy cert ────────────────────────────────────
echo "==> Starting nginx..."
docker compose up --force-recreate -d portfolio
echo "    Waiting for nginx to be ready..."
sleep 5

# ── 3. Delete the dummy cert ──────────────────────────────────────────────
echo "==> Removing dummy certificate..."
docker compose run --rm --entrypoint "sh -c ' \
  rm -rf /etc/letsencrypt/live/${DOMAIN} \
         /etc/letsencrypt/archive/${DOMAIN} \
         /etc/letsencrypt/renewal/${DOMAIN}.conf \
'" certbot

# ── 4. Request the real Let's Encrypt certificate ─────────────────────────
echo "==> Requesting Let's Encrypt certificate..."
docker compose run --rm --entrypoint "sh -c ' \
  certbot certonly \
    --webroot -w ${WEBROOT} \
    --email ${EMAIL} \
    ${DOMAINS} \
    --rsa-key-size 4096 \
    --agree-tos \
    --no-eff-email \
'" certbot

# ── 5. Reload nginx with the real cert ────────────────────────────────────
echo "==> Reloading nginx..."
docker compose exec portfolio nginx -s reload

# ── 6. Start the certbot renewal loop ─────────────────────────────────────
echo "==> Starting certbot renewal loop..."
docker compose up -d certbot

echo ""
echo "Done! galic.dev is live at https://${DOMAIN}"
