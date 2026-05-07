# ─── Stage 1: Build ──────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

# ─── Stage 2: Serve ──────────────────────────────────────────────
FROM nginx:1.25-alpine

RUN apk add --no-cache openssl

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/portfolio.conf
COPY nginx-start.sh /nginx-start.sh
RUN chmod +x /nginx-start.sh

EXPOSE 80 443
CMD ["/nginx-start.sh"]
