<template>
  <section id="skills" class="section skills">
    <div class="skills__bg-accent"></div>
    <div class="container">
      <div ref="headerRef" class="skills__header reveal-hidden">
        <p class="mono text-accent skills__label">// skills</p>
        <h2 class="section-title">Tech Stack<span class="accent-dot">.</span></h2>
        <p class="section-subtitle">A selection of technologies I work with on a daily basis.</p>
      </div>

      <div class="skills__grid">
        <div
          v-for="(category, ci) in skillCategories"
          :key="category.id"
          :ref="el => cardRefs[ci] = el"
          class="skills__category reveal-hidden"
        >
          <div class="skills__cat-header">
            <v-icon color="primary" size="22">{{ category.icon }}</v-icon>
            <span class="skills__cat-title">{{ category.label }}</span>
          </div>

          <div class="skills__items">
            <div v-for="skill in category.skills" :key="skill.name" class="skills__item">
              <div class="skills__item-top">
                <div class="skills__item-name">
                  <v-icon size="18" color="primary" class="mr-1">{{ skill.icon }}</v-icon>
                  {{ skill.name }}
                </div>
                <span class="skills__item-level mono">{{ skill.level }}%</span>
              </div>
              <div class="skills__bar-track">
                <div
                  class="skills__bar-fill"
                  :style="{ '--fill-width': skill.level + '%' }"
                  :data-animated="false"
                ></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Certifications -->
      <div ref="certsRef" class="skills__certs reveal-hidden">
        <p class="mono text-accent skills__label">// certifications</p>
        <div class="skills__certs-list">
          <div v-for="cert in certs" :key="cert.name" class="skills__cert-card">
            <v-icon color="primary" size="28">mdi-certificate</v-icon>
            <div>
              <p class="skills__cert-name">{{ cert.name }}</p>
              <p class="skills__cert-issuer">{{ cert.issuer }}</p>
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
import { skillCategories } from '@/data/skills.js'

gsap.registerPlugin(ScrollTrigger)

const headerRef = ref(null)
const cardRefs  = ref([])
const certsRef  = ref(null)

const certs = [
  { name: 'Certified Exposure Management Expert', issuer: 'Cymulate' },
  { name: 'ITLS — International Trauma Life Support', issuer: 'ITLS International' },
]

onMounted(() => {
  gsap.to(headerRef.value, {
    opacity: 1, y: 0, duration: 0.8, ease: 'power3.out',
    scrollTrigger: { trigger: headerRef.value, start: 'top 85%' }
  })

  cardRefs.value.forEach((el, i) => {
    gsap.to(el, {
      opacity: 1, y: 0, duration: 0.7, delay: i * 0.08, ease: 'power3.out',
      scrollTrigger: { trigger: el, start: 'top 88%',
        onEnter: () => animateBars(el)
      }
    })
  })

  gsap.to(certsRef.value, {
    opacity: 1, y: 0, duration: 0.8, ease: 'power3.out',
    scrollTrigger: { trigger: certsRef.value, start: 'top 85%' }
  })
})

function animateBars(categoryEl) {
  const bars = categoryEl.querySelectorAll('.skills__bar-fill')
  bars.forEach((bar) => {
    if (bar.dataset.animated === 'true') return
    bar.dataset.animated = 'true'
    gsap.fromTo(bar, { width: 0 }, {
      width: bar.style.getPropertyValue('--fill-width') || '0%',
      duration: 1.2, ease: 'power2.out'
    })
  })
}
</script>

<style scoped lang="scss">
.skills {
  background: var(--bg-secondary);
  position: relative;
  overflow: hidden;
}

.skills__bg-accent {
  position: absolute;
  top: -200px;
  right: -200px;
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(229, 57, 53, 0.07) 0%, transparent 70%);
  pointer-events: none;
}

.skills__header {
  margin-bottom: 60px;
}

.skills__label {
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  margin-bottom: 12px;
}

.skills__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 24px;
  margin-bottom: 60px;

  @media (max-width: 600px) {
    grid-template-columns: 1fr;
  }
}

.skills__category {
  background: var(--bg-primary);
  border: 1px solid rgba(229, 57, 53, 0.12);
  border-radius: 16px;
  padding: 24px;
  transition: border-color 0.25s, box-shadow 0.25s;

  &:hover {
    border-color: rgba(229, 57, 53, 0.35);
    box-shadow: 0 0 20px rgba(229, 57, 53, 0.1);
  }
}

.skills__cat-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
}

.skills__cat-title {
  font-weight: 600;
  font-size: 1rem;
  color: var(--text-primary);
}

.skills__items {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.skills__item-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.skills__item-name {
  display: flex;
  align-items: center;
  font-size: 0.875rem;
  color: var(--text-muted);
}

.skills__item-level {
  font-size: 0.75rem;
  color: var(--accent);
}

.skills__bar-track {
  height: 4px;
  background: rgba(255, 255, 255, 0.06);
  border-radius: 2px;
  overflow: hidden;
}

.skills__bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #E53935, #FF5252);
  border-radius: 2px;
  width: 0;
  box-shadow: 0 0 8px rgba(229, 57, 53, 0.5);
}

/* ─── Certs ──────────────────────────────────────────────────────── */
.skills__certs {
  border-top: 1px solid rgba(229, 57, 53, 0.12);
  padding-top: 40px;
}

.skills__certs-list {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
  margin-top: 20px;
}

.skills__cert-card {
  display: flex;
  align-items: center;
  gap: 16px;
  background: var(--bg-primary);
  border: 1px solid rgba(229, 57, 53, 0.15);
  border-radius: 14px;
  padding: 20px 24px;
  flex: 1;
  min-width: 260px;
  transition: border-color 0.2s, box-shadow 0.2s;

  &:hover {
    border-color: rgba(229, 57, 53, 0.4);
    box-shadow: 0 0 20px rgba(229, 57, 53, 0.1);
  }
}

.skills__cert-name {
  font-weight: 600;
  font-size: 0.9rem;
  color: var(--text-primary);
}

.skills__cert-issuer {
  font-size: 0.8rem;
  color: var(--text-muted);
  margin-top: 2px;
}
</style>
