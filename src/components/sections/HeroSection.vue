<template>
  <section id="hero" class="hero">
    <ParticlesBackground />

    <!-- Background grid overlay -->
    <div class="hero__grid bg-grid"></div>

    <!-- Gradient overlays -->
    <div class="hero__gradient hero__gradient--bottom"></div>

    <!-- Pulsing red spotlight behind the name -->
    <div class="hero__spotlight" aria-hidden="true"></div>

    <div class="container hero__content">
      <!-- Greeting line -->
      <p ref="greetRef" class="hero__greeting mono reveal-hidden">
        <span class="text-accent">$</span>&nbsp;<span ref="scrambleRef">hello --world</span>
      </p>

      <!-- Name with glitch -->
      <h1 ref="nameRef" class="hero__name reveal-hidden">
        <GlitchText text="Mijo Galić" auto />
        <span class="accent-dot">.</span>
      </h1>

      <!-- Typing roles -->
      <p ref="roleRef" class="hero__role reveal-hidden">
        I am a&nbsp;<TypingText :strings="typingStrings" />
      </p>

      <!-- Bio -->
      <p ref="bioRef" class="hero__bio reveal-hidden">
        Software Engineer from Mostar, Bosnia &amp; Herzegovina. Passionate about embedded systems,
        cybersecurity, machine learning, and building things that matter.
      </p>

      <!-- CTAs -->
      <div ref="ctaRef" class="hero__ctas reveal-hidden">
        <div :ref="el => { if (el) magEls[0] = el }" @mousemove="onMag($event, 0)" @mouseleave="offMag(0)">
          <v-btn
            color="primary"
            size="large"
            class="hero__cta-primary"
            @click="scrollTo('projects')"
          >
            <v-icon start>mdi-code-braces</v-icon>
            View My Work
          </v-btn>
        </div>
        <div :ref="el => { if (el) magEls[1] = el }" @mousemove="onMag($event, 1)" @mouseleave="offMag(1)">
          <v-btn
            variant="outlined"
            color="primary"
            size="large"
            class="hero__cta-secondary"
            @click="scrollTo('contact')"
          >
            <v-icon start>mdi-email-outline</v-icon>
            Contact Me
          </v-btn>
        </div>
      </div>

      <!-- Social quick links -->
      <div ref="socialRef" class="hero__socials reveal-hidden">
        <a
          v-for="link in socialLinks"
          :key="link.label"
          :href="link.href"
          :aria-label="link.label"
          target="_blank"
          rel="noopener noreferrer"
          class="hero__social-link"
        >
          <v-icon size="22">{{ link.icon }}</v-icon>
        </a>
      </div>
    </div>

    <!-- Tech stack ticker -->
    <div class="hero__ticker" aria-hidden="true">
      <div class="hero__ticker-track">
        <span v-for="tech in [...techStack, ...techStack]" :key="Math.random()" class="hero__ticker-item">
          <v-icon size="10" color="rgba(229,57,53,0.55)">mdi-circle</v-icon>
          {{ tech }}
        </span>
      </div>
    </div>

    <!-- Scroll down indicator -->
    <button class="hero__scroll-down scroll-bounce" @click="scrollTo('about')" aria-label="Scroll down">
      <v-icon size="32" color="rgba(240,244,255,0.5)">mdi-chevron-double-down</v-icon>
    </button>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { gsap } from 'gsap'
import GlitchText from '@/components/GlitchText.vue'
import TypingText from '@/components/TypingText.vue'
import ParticlesBackground from '@/components/ParticlesBackground.vue'

const greetRef   = ref(null)
const nameRef    = ref(null)
const roleRef    = ref(null)
const bioRef     = ref(null)
const ctaRef     = ref(null)
const socialRef  = ref(null)
const scrambleRef = ref(null)
const magEls     = []

const typingStrings = [
  'Software Engineer.',
  'Backend Developer.',
  'Cybersecurity Enthusiast.',
  'ML / CV Engineer.',
  'IoT Systems Builder.',
  'Problem Solver.',
]

const techStack = [
  'Java', 'Python', 'Node.js', 'Vue.js', 'Machine Learning', 'Computer Vision',
  'IoT', 'Embedded Systems', 'Cybersecurity', 'Network Architecture',
  'Redis', 'Linux', 'Docker', 'ANPR', 'OpenCV', 'TypeScript', 'Android',
  'C++', 'MySQL', 'Business Automation', 'AI',
]

const socialLinks = [
  { label: 'GitHub',   icon: 'mdi-github',   href: 'https://github.com/gmijo47' },
  { label: 'LinkedIn', icon: 'mdi-linkedin',  href: 'https://www.linkedin.com/in/galić-mijo-0145241bb/' },
  { label: 'Email',    icon: 'mdi-email',     href: 'mailto:gmijo47@gmail.com' },
  { label: 'Twitter',  icon: 'mdi-twitter',   href: 'https://twitter.com/gmijo47' },
]

function scrollTo(id) {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}

// ── Magnetic CTA ──────────────────────────────────────────────────
function onMag(e, i) {
  const el = magEls[i]
  if (!el) return
  const r  = el.getBoundingClientRect()
  const dx = (e.clientX - (r.left + r.width  / 2)) * 0.38
  const dy = (e.clientY - (r.top  + r.height / 2)) * 0.38
  gsap.to(el, { x: dx, y: dy, duration: 0.3, ease: 'power2.out' })
}

function offMag(i) {
  if (!magEls[i]) return
  gsap.to(magEls[i], { x: 0, y: 0, duration: 0.9, ease: 'elastic.out(1, 0.35)' })
}

// ── Character scramble ────────────────────────────────────────────
const CHARS = '!<>-_/[]{}=+*^?#@ABCDabcd0123456789'

function scramble(el, text, duration = 1.5) {
  if (!el) return
  const total = Math.round(duration * 60)
  let frame = 0
  const tick = () => {
    const progress = frame / total
    const resolved = Math.floor(progress * text.length)
    el.textContent = text
      .split('')
      .map((ch, i) => {
        if (ch === ' ') return ' '
        if (i < resolved) return ch
        return CHARS[Math.floor(Math.random() * CHARS.length)]
      })
      .join('')
    frame++
    if (frame <= total) requestAnimationFrame(tick)
    else el.textContent = text
  }
  requestAnimationFrame(tick)
}

onMounted(() => {
  const els = [greetRef.value, nameRef.value, roleRef.value, bioRef.value, ctaRef.value, socialRef.value]

  // Brutal start state — overrides reveal-hidden CSS
  gsap.set(els, {
    opacity: 0,
    y: 90,
    rotationX: -30,
    scale: 0.88,
    transformPerspective: 1200,
  })

  const tl = gsap.timeline({ delay: 0.25 })

  tl.to(greetRef.value, {
    opacity: 1, y: 0, rotationX: 0, scale: 1,
    duration: 0.9, ease: 'back.out(2.2)',
    onStart: () => scramble(scrambleRef.value, 'hello --world'),
  })
  .to(nameRef.value, {
    opacity: 1, y: 0, rotationX: 0, scale: 1,
    duration: 1.0, ease: 'back.out(2.5)',
  }, '-=0.55')
  .to(roleRef.value, {
    opacity: 1, y: 0, rotationX: 0, scale: 1,
    duration: 0.85, ease: 'back.out(2)',
  }, '-=0.5')
  .to(bioRef.value, {
    opacity: 1, y: 0, rotationX: 0, scale: 1,
    duration: 0.8, ease: 'power3.out',
  }, '-=0.45')
  .to(ctaRef.value, {
    opacity: 1, y: 0, rotationX: 0, scale: 1,
    duration: 0.8, ease: 'back.out(1.8)',
  }, '-=0.4')
  .to(socialRef.value, {
    opacity: 1, y: 0, rotationX: 0, scale: 1,
    duration: 0.7, ease: 'power3.out',
  }, '-=0.35')
})
</script>

<style scoped lang="scss">
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;
  background: var(--bg-primary);
}

.hero__grid {
  position: absolute;
  inset: 0;
  opacity: 0.4;
  pointer-events: none;
}

.hero__gradient {
  position: absolute;
  left: 0;
  right: 0;
  pointer-events: none;

  &--bottom {
    bottom: 0;
    height: 200px;
    background: linear-gradient(to top, var(--bg-primary), transparent);
  }
}

.hero__content {
  position: relative;
  z-index: 1;
  padding-top: 120px;
  padding-bottom: 80px;
  text-align: center;
}

.hero__greeting {
  font-size: 1rem;
  color: var(--text-muted);
  margin-bottom: 16px;
  letter-spacing: 0.05em;
}

.hero__name {
  font-size: clamp(3rem, 9vw, 7rem);
  font-weight: 700;
  line-height: 1.05;
  margin-bottom: 20px;
  color: var(--text-primary);
}

.hero__role {
  font-size: clamp(1.2rem, 3vw, 1.8rem);
  font-weight: 400;
  color: var(--text-muted);
  margin-bottom: 24px;
  min-height: 2.4em;
}

.hero__bio {
  max-width: 560px;
  margin: 0 auto 40px;
  color: var(--text-muted);
  font-size: 1.05rem;
  line-height: 1.75;
}

.hero__ctas {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 48px;
  justify-content: center;
}

.hero__mag {
  display: inline-block;
}

.hero__cta-primary {
  font-weight: 600;
  letter-spacing: 0.03em;
  box-shadow: 0 0 20px rgba(229, 57, 53, 0.4);
  transition: box-shadow 0.3s ease, transform 0.2s ease;

  &:hover {
    box-shadow: 0 0 40px rgba(229, 57, 53, 0.7);
    transform: translateY(-2px);
  }
}

.hero__cta-secondary {
  font-weight: 600;
  letter-spacing: 0.03em;
  transition: background 0.25s, transform 0.2s, color 0.25s;

  &:hover {
    background: var(--accent) !important;
    transform: translateY(-2px);

    :deep(.v-btn__content),
    :deep(.v-icon) {
      color: #fff !important;
    }
  }
}

.hero__socials {
  display: flex;
  gap: 20px;
  justify-content: center;
}

.hero__social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  border: 1px solid rgba(229, 57, 53, 0.3);
  color: var(--text-muted);
  text-decoration: none;
  transition: color 0.2s, border-color 0.2s, background 0.2s, transform 0.2s;

  &:hover {
    color: var(--accent);
    border-color: var(--accent);
    background: rgba(229, 57, 53, 0.1);
    transform: translateY(-3px);
  }
}

/* ─── Tech Ticker ────────────────────────────────────────────────── */
.hero__ticker {
  position: relative;
  z-index: 1;
  overflow: hidden;
  border-top: 1px solid rgba(229, 57, 53, 0.12);
  border-bottom: 1px solid rgba(229, 57, 53, 0.12);
  padding: 10px 0;
  margin-top: 40px;
}

.hero__ticker-track {
  display: flex;
  width: max-content;
  gap: 28px;
  animation: ticker-scroll 35s linear infinite;
}

@keyframes ticker-scroll {
  from { transform: translateX(0); }
  to   { transform: translateX(-50%); }
}

.hero__ticker-item {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.78rem;
  color: var(--text-muted);
  white-space: nowrap;
  letter-spacing: 0.04em;
}

.hero__scroll-down {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  background: none;
  border: none;
  cursor: pointer;
  z-index: 1;
}

/* ─── Spotlight ──────────────────────────────────────────────────── */
.hero__spotlight {
  position: absolute;
  top: 38%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 900px;
  height: 450px;
  background: radial-gradient(ellipse, rgba(229, 57, 53, 0.10) 0%, transparent 65%);
  pointer-events: none;
  z-index: 0;
  animation: spotlight-pulse 5s ease-in-out infinite;
}

@keyframes spotlight-pulse {
  0%, 100% {
    opacity: 0.55;
    transform: translate(-50%, -50%) scale(1);
  }
  50% {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1.22);
  }
}

/* ─── Scanlines overlay ──────────────────────────────────────────── */
.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 3px,
    rgba(0, 0, 0, 0.035) 3px,
    rgba(0, 0, 0, 0.035) 4px
  );
  pointer-events: none;
  z-index: 2;
  animation: scanlines-drift 12s linear infinite;
}

@keyframes scanlines-drift {
  from { background-position: 0 0; }
  to   { background-position: 0 240px; }
}
</style>
