# galic.dev — Personal Portfolio

Personal portfolio of **Mijo Galić**, Software Engineer from Bosnia and Herzegovina.  
Built with Vue 3 + Vuetify 3, deployed at [galic.dev](https://galic.dev) via Docker + Let's Encrypt.

## Tech Stack

| Layer | Tools |
|---|---|
| Frontend | Vue 3 (Composition API), Vuetify 3, SCSS |
| Animations | GSAP 3 + ScrollTrigger, tsParticles, typed.js |
| Build | Vite 5 |
| Serve | Nginx 1.25 |
| HTTPS | Certbot (Let's Encrypt, webroot) |
| Deploy | Docker + Docker Compose |

## Local Development

```bash
npm install
npm run dev
```

Runs on `http://localhost:5173`.

## Production Build

```bash
npm run build
```

Output in `dist/`.

## Docker Deployment (HTTPS)

### First time — acquiring the certificate

```bash
# 1. Start nginx (HTTP only works at this point)
docker compose up -d portfolio

# 2. Acquire Let's Encrypt cert via webroot
docker compose run --rm certbot certonly \
  --webroot -w /var/www/certbot \
  --email gmijo47@gmail.com --agree-tos --no-eff-email \
  -d galic.dev -d www.galic.dev

# 3. Restart nginx to load the cert
docker compose restart portfolio

# 4. Start the certbot renewal loop
docker compose up -d certbot
```

### Subsequent deploys (code update)

```bash
docker compose up -d --build portfolio
```

Certbot keeps running and auto-renews every 12 hours. No manual cert work needed.

### Prerequisites

- Port 80 and 443 open on the server
- DNS A record for `galic.dev` (and optionally `www.galic.dev`) pointing to the server IP

## Project Structure

```
├── public/
│   └── favicon.svg
├── src/
│   ├── assets/styles/      # SCSS variables, animations, main
│   ├── components/
│   │   ├── sections/       # HeroSection, AboutSection, ServicesSection,
│   │   │                   # SkillsSection, ProjectsSection,
│   │   │                   # GitHubStatsSection, ContactSection
│   │   ├── GlitchText.vue
│   │   ├── NavBar.vue
│   │   ├── ParticlesBackground.vue
│   │   └── TypingText.vue
│   ├── data/
│   │   ├── projects.js     # 13 real projects
│   │   └── skills.js       # Skill categories + levels
│   ├── plugins/
│   │   └── vuetify.js
│   ├── App.vue
│   └── main.js
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
└── vite.config.js
```

## License

All rights reserved — Mijo Galić.
