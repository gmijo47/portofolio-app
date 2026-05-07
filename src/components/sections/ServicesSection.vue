<template>
  <section id="services" class="section services">
    <!-- Ambient drifting orbs -->
    <div class="services__bg" aria-hidden="true">
      <div class="services__orb services__orb--1"></div>
      <div class="services__orb services__orb--2"></div>
      <div class="services__orb services__orb--3"></div>
    </div>

    <div class="container">
      <div ref="headerRef" class="services__header">
        <p class="mono text-accent services__label">// services</p>
        <h2 class="section-title">What I Offer<span class="accent-dot">.</span></h2>
        <p class="section-subtitle services__subtitle">
          From concept to deployment — AI systems, automation pipelines and full-stack digital solutions.
        </p>
      </div>

      <div class="services__grid">
        <div
          v-for="(svc, i) in services"
          :key="svc.id"
          :ref="el => { if (el) cardRefs[i] = el }"
          class="service-card"
          @mousemove="onMove($event, i)"
          @mouseleave="onLeave(i)"
        >
          <!-- Ghost number watermark -->
          <span class="service-card__ghost">0{{ i + 1 }}</span>

          <!-- Sweep overlay (triggered by hover via CSS) -->
          <div class="service-card__sweep"></div>

          <!-- Icon area -->
          <div class="service-card__icon-wrap">
            <div class="service-card__ring" :style="{ '--c': svc.color }"></div>
            <div class="service-card__icon-bg" :style="{ background: `${svc.color}18` }">
              <v-icon size="38" :color="svc.color">{{ svc.icon }}</v-icon>
            </div>
          </div>

          <p class="service-card__sub mono" :style="{ color: svc.color }">{{ svc.subtitle }}</p>
          <h3 class="service-card__title">{{ svc.title }}</h3>
          <p class="service-card__desc">{{ svc.desc }}</p>

          <div class="service-card__tags">
            <span v-for="tag in svc.tags" :key="tag" class="service-card__tag">{{ tag }}</span>
          </div>

          <!-- Sliding bottom accent bar -->
          <div class="service-card__bar" :style="{ '--c': svc.color }"></div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

const headerRef = ref(null)
const cardRefs  = ref([])

const services = [
  {
    id: 1,
    icon: 'mdi-brain',
    title: 'Artificial Intelligence',
    subtitle: 'ML · Computer Vision · NLP',
    desc: 'Custom machine learning pipelines, computer vision systems and AI-driven automation — trained, optimized and deployed end-to-end for real production environments.',
    tags: ['Machine Learning', 'Computer Vision', 'Python', 'OpenCV', 'TensorFlow', 'NLP'],
    color: '#E53935',
  },
  {
    id: 2,
    icon: 'mdi-robot-industrial-outline',
    title: 'Business Process Automation',
    subtitle: 'RPA · Workflow Engineering',
    desc: 'Identify, digitalize and automate repetitive workflows — cutting overhead, eliminating manual errors and scaling operations efficiently without adding headcount.',
    tags: ['RPA', 'Node.js', 'Java', 'API Integration', 'Process Design', 'Backend'],
    color: '#448AFF',
  },
  {
    id: 3,
    icon: 'mdi-chip',
    title: 'Digitalization & Integration',
    subtitle: 'IoT · System Architecture',
    desc: 'Modernize analog operations with connected smart systems — IoT integration, legacy system migration, backend APIs and full architecture design from ground up.',
    tags: ['IoT', 'Embedded', 'REST API', 'Docker', 'Linux', 'System Design'],
    color: '#69F0AE',
  },
]

function onMove(e, i) {
  const el = cardRefs.value[i]
  if (!el) return
  const r = el.getBoundingClientRect()
  const x = ((e.clientX - r.left) / r.width  - 0.5) * 22
  const y = ((e.clientY - r.top)  / r.height - 0.5) * -22
  gsap.to(el, {
    rotationY: x, rotationX: y, scale: 1.04,
    duration: 0.3, ease: 'power2.out', transformPerspective: 900,
  })
}

function onLeave(i) {
  const el = cardRefs.value[i]
  if (!el) return
  gsap.to(el, {
    rotationY: 0, rotationX: 0, scale: 1,
    duration: 0.8, ease: 'elastic.out(1, 0.4)',
  })
}

onMounted(() => {
  // Header reveal
  gsap.from(headerRef.value, {
    opacity: 0, y: 60, duration: 1, ease: 'power3.out',
    scrollTrigger: { trigger: headerRef.value, start: 'top 80%' },
  })

  // Cards staggered entrance with bounce + depth
  cardRefs.value.forEach((el, i) => {
    if (!el) return
    gsap.from(el, {
      opacity: 0,
      y: 100,
      rotationX: 35,
      scale: 0.88,
      duration: 0.95,
      delay: i * 0.2,
      ease: 'back.out(1.9)',
      scrollTrigger: { trigger: el, start: 'top 90%' },
    })
  })
})
</script>

<style scoped lang="scss">
.services {
  background: var(--bg-secondary);
  position: relative;
  overflow: hidden;
}

/* ── Ambient Orbs ─────────────────────────────────── */
.services__bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
}

.services__orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(110px);

  &--1 {
    width: 520px; height: 520px;
    background: radial-gradient(circle, rgba(229,57,53,.07) 0%, transparent 70%);
    top: -160px; left: -160px;
    animation: orb-float 14s ease-in-out infinite alternate;
  }
  &--2 {
    width: 420px; height: 420px;
    background: radial-gradient(circle, rgba(68,138,255,.055) 0%, transparent 70%);
    top: 40%; right: -130px;
    animation: orb-float 19s ease-in-out infinite alternate-reverse;
  }
  &--3 {
    width: 360px; height: 360px;
    background: radial-gradient(circle, rgba(105,240,174,.045) 0%, transparent 70%);
    bottom: -100px; left: 42%;
    animation: orb-float 24s ease-in-out infinite alternate;
  }
}

@keyframes orb-float {
  from { transform: translate(0,   0) scale(1); }
  to   { transform: translate(40px, 28px) scale(1.18); }
}

/* ── Header ───────────────────────────────────────── */
.services__header {
  position: relative;
  z-index: 1;
  text-align: center;
  margin-bottom: 64px;
}

.services__label {
  font-size: .9rem;
  letter-spacing: .1em;
  margin-bottom: 12px;
}

.services__subtitle {
  max-width: 520px;
  margin: 16px auto 0;
}

/* ── Grid ─────────────────────────────────────────── */
.services__grid {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 28px;

  @media (max-width: 1024px) { grid-template-columns: repeat(2, 1fr); }
  @media (max-width: 640px)  { grid-template-columns: 1fr; }
}

/* ── Card ─────────────────────────────────────────── */
.service-card {
  position: relative;
  background: var(--bg-primary);
  border: 1px solid rgba(240,244,255,.06);
  border-radius: 22px;
  padding: 40px 32px 48px;
  overflow: hidden;
  cursor: default;
  transform-style: preserve-3d;
  transition: border-color .3s;

  &:hover {
    border-color: rgba(240,244,255,.16);

    .service-card__sweep {
      animation: card-sweep .6s ease-out forwards;
    }

    .service-card__bar {
      width: 100%;
    }

    .service-card__ring {
      animation: ring-pulse 1.1s ease-out infinite;
    }

    .service-card__icon-bg {
      transform: scale(1.08);
    }
  }
}

/* Ghost number watermark */
.service-card__ghost {
  position: absolute;
  top: 12px;
  right: 22px;
  font-family: 'Space Grotesk', sans-serif;
  font-size: 5.5rem;
  font-weight: 800;
  color: rgba(240,244,255,.025);
  line-height: 1;
  user-select: none;
  pointer-events: none;
}

/* Sweep highlight */
.service-card__sweep {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom,
    transparent 0%,
    rgba(229,57,53,.045) 50%,
    transparent 100%
  );
  transform: translateY(-100%);
  pointer-events: none;
}

@keyframes card-sweep {
  from { transform: translateY(-100%); }
  to   { transform: translateY(100%); }
}

/* Icon area */
.service-card__icon-wrap {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
}

.service-card__icon-bg {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 72px;
  height: 72px;
  border-radius: 18px;
  transition: transform .35s ease;
}

.service-card__ring {
  position: absolute;
  inset: -6px;
  border-radius: 24px;
  border: 1.5px solid var(--c, #E53935);
  opacity: .22;
}

@keyframes ring-pulse {
  0%   { transform: scale(1);    opacity: .22; }
  55%  { transform: scale(1.3);  opacity: .05; }
  100% { transform: scale(1);    opacity: .22; }
}

/* Text */
.service-card__sub {
  font-size: .76rem;
  letter-spacing: .1em;
  margin-bottom: 8px;
}

.service-card__title {
  font-family: 'Space Grotesk', sans-serif;
  font-size: 1.45rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 14px;
}

.service-card__desc {
  font-size: .91rem;
  color: var(--text-muted);
  line-height: 1.7;
  margin-bottom: 24px;
}

/* Tags */
.service-card__tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.service-card__tag {
  font-family: 'JetBrains Mono', monospace;
  font-size: .69rem;
  padding: 3px 10px;
  border-radius: 4px;
  background: rgba(240,244,255,.05);
  color: var(--text-muted);
  border: 1px solid rgba(240,244,255,.07);
  white-space: nowrap;
}

/* Bottom sliding bar */
.service-card__bar {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  width: 0;
  background: var(--c, #E53935);
  border-radius: 0 3px 0 0;
  transition: width .5s cubic-bezier(.4,0,.2,1);
}
</style>
