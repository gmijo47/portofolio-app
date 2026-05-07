<template>
  <section id="about" class="section about">
    <div class="container">
      <div class="about__grid">
        <!-- Left: Text -->
        <div ref="textRef" class="about__text reveal-hidden-left">
          <p class="mono text-accent about__label">// about me</p>
          <h2 class="section-title">Who Am I<span class="accent-dot">?</span></h2>
          <p class="section-subtitle" style="margin-bottom: 24px;">
            Even as a little boy, I did not separate myself from the computer — exploring every possible
            hardware and software aspect, playing games, and just picking up knowledge.
            That curiosity never left me.
          </p>
          <p class="about__body">
            Based in Mostar, Bosnia and Herzegovina — building at the intersection of
            <strong>backend systems</strong>, <strong>IoT</strong>, <strong>ML</strong> and
            <strong>cybersecurity</strong>. Resourceful, curious and extremely persistent — started
            tinkering with hardware and software long before it became a career.
          </p>
          <p class="about__body">
            Experienced across the full stack: from low-level embedded firmware and network architecture
            to AI-driven automation and computer vision. Holds a <strong>Bachelor's in Information
            Technology</strong> and is pursuing a <strong>Master's in Data Science &amp; Engineering</strong>
            at the University of Mostar.
          </p>

          <!-- Stats row -->
          <div class="about__stats">
            <div v-for="(stat, i) in stats" :key="stat.label" class="about__stat">
              <span class="about__stat-number neon-text">
                {{ Math.round(displayedStats[i]) }}{{ stat.value.replace(/[0-9]/g, '') }}
              </span>
              <span class="about__stat-label">{{ stat.label }}</span>
            </div>
          </div>

          <!-- Awards -->
          <div class="about__awards">
            <v-chip
              v-for="award in awards"
              :key="award"
              size="small"
              color="primary"
              variant="tonal"
              class="mr-2 mb-2"
            >
              <v-icon start size="14">mdi-trophy</v-icon>
              {{ award }}
            </v-chip>
          </div>
        </div>

        <!-- Right: Avatar card -->
        <div ref="avatarRef" class="about__avatar-wrap reveal-hidden-right">
          <div class="about__avatar float">
            <div class="about__avatar-inner">
              <span class="about__initials">MG</span>
            </div>
            <div class="about__avatar-ring"></div>
          </div>

          <!-- Info pills -->
          <div class="about__info-pills">
            <div v-for="info in infoPills" :key="info.label" class="about__pill">
              <v-icon size="18" color="primary">{{ info.icon }}</v-icon>
              <span>{{ info.text }}</span>
            </div>
          </div>
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

const textRef  = ref(null)
const avatarRef = ref(null)

const stats = [
  { value: '7+',  raw: 7,  label: 'Years Experience' },
  { value: '50+', raw: 50, label: 'GitHub Repos' },
  { value: '6+',  raw: 6,  label: 'Companies' },
  { value: '10+', raw: 10, label: 'Awards' },
]

const displayedStats = ref(stats.map(() => 0))

function animateCounters() {
  stats.forEach((stat, i) => {
    // Use a plain object so GSAP never loses its reference
    const proxy = { val: 0 }
    gsap.to(proxy, {
      val: stat.raw,
      duration: 2.2,
      delay: i * 0.18,
      ease: 'power3.out',
      onUpdate() {
        displayedStats.value[i] = proxy.val
      },
      onComplete() {
        // Slam: briefly scale up + glow red, then settle
        const el = document.querySelectorAll('.about__stat-number')[i]
        if (el) {
          gsap.fromTo(
            el,
            { scale: 1.35, textShadow: '0 0 28px rgba(229,57,53,0.95)' },
            { scale: 1,    textShadow: '0 0 0px rgba(229,57,53,0)',
              duration: 0.55, ease: 'back.out(3.5)' }
          )
        }
      },
    })
  })
}

const awards = [
  'Winner m:tel App 2022',
  'MVP Evona Hack 2022',
  'Winner Evona Hack 2022',
  "Dean's Award 2025",
  '2nd place SUMIT Smart Campus',
]

const infoPills = [
  { icon: 'mdi-map-marker', text: 'Mostar, Bosnia & Herzegovina' },
  { icon: 'mdi-school', text: 'MSc Data Science & Engineering' },
  { icon: 'mdi-briefcase', text: 'Software Engineer' },
  { icon: 'mdi-certificate', text: 'Certified Exposure Management Expert' },
]

onMounted(() => {
  gsap.to(textRef.value, {
    opacity: 1, x: 0, duration: 0.9, ease: 'power3.out',
    scrollTrigger: {
      trigger: textRef.value, start: 'top 85%', once: true,
      onEnter: () => animateCounters(),
    }
  })
  gsap.to(avatarRef.value, {
    opacity: 1, x: 0, duration: 0.9, delay: 0.15, ease: 'power3.out',
    scrollTrigger: { trigger: avatarRef.value, start: 'top 85%', once: true }
  })
})
</script>

<style scoped lang="scss">
.about {
  background: var(--bg-primary);
}

.about__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 80px;
  align-items: center;

  @media (max-width: 900px) {
    grid-template-columns: 1fr;
    gap: 60px;
  }
}

.about__label {
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  margin-bottom: 12px;
}

.about__body {
  color: var(--text-muted);
  line-height: 1.8;
  margin-bottom: 16px;
}

.about__stats {
  display: flex;
  gap: 32px;
  margin: 32px 0 24px;
  flex-wrap: wrap;
}

.about__stat {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.about__stat-number {
  font-size: 2rem;
  font-weight: 700;
  font-family: 'JetBrains Mono', monospace;
}

.about__stat-label {
  font-size: 0.8rem;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.about__awards {
  display: flex;
  flex-wrap: wrap;
}

/* ─── Avatar ─────────────────────────────────────────────────────── */
.about__avatar-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 32px;
}

.about__avatar {
  position: relative;
  width: 220px;
  height: 220px;

  @media (max-width: 900px) { width: 160px; height: 160px; }
}

.about__avatar-inner {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: linear-gradient(135deg, #E53935 0%, #1565C0 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 60px rgba(229, 57, 53, 0.35);
}

.about__initials {
  font-size: 4rem;
  font-weight: 700;
  color: white;
  font-family: 'JetBrains Mono', monospace;

  @media (max-width: 900px) { font-size: 2.8rem; }
}

.about__avatar-ring {
  position: absolute;
  inset: -12px;
  border-radius: 50%;
  border: 2px dashed rgba(229, 57, 53, 0.4);
  animation: spin 18s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

/* ─── Info pills ─────────────────────────────────────────────────── */
.about__info-pills {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
  max-width: 320px;
}

.about__pill {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--bg-secondary);
  border: 1px solid rgba(229, 57, 53, 0.15);
  border-radius: 12px;
  padding: 10px 16px;
  font-size: 0.875rem;
  color: var(--text-muted);
  transition: border-color 0.2s, background 0.2s;

  &:hover {
    border-color: rgba(229, 57, 53, 0.4);
    background: rgba(229, 57, 53, 0.05);
  }
}
</style>
