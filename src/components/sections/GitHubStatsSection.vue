<template>
  <section id="github" class="section github-stats">
    <div class="container">
      <div ref="headerRef" class="github-stats__header reveal-hidden">
        <p class="mono text-accent github-stats__label">// github</p>
        <h2 class="section-title">GitHub Activity<span class="accent-dot">.</span></h2>
        <p class="section-subtitle">Live stats from my GitHub profile.</p>
      </div>

      <div class="github-stats__grid">
        <div
          v-for="(card, i) in statCards"
          :key="card.alt"
          :ref="el => cardRefs[i] = el"
          class="github-stats__card reveal-hidden"
          :class="{ 'github-stats__card--wide': card.wide }"
        >
          <img
            :src="card.src"
            :alt="card.alt"
            loading="lazy"
            class="github-stats__img"
            @error="e => e.target.style.display = 'none'"
          />
        </div>
      </div>

      <!-- Contribution Activity link -->
      <div ref="linkRef" class="github-stats__link reveal-hidden">
        <v-btn
          variant="text"
          color="primary"
          href="https://github.com/gmijo47"
          target="_blank"
          rel="noopener"
        >
          <v-icon start>mdi-open-in-new</v-icon>
          View Full GitHub Profile
        </v-btn>
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
const linkRef   = ref(null)

const BASE = 'https://github-readme-stats.vercel.app/api'
const USERNAME = 'gmijo47'
const THEME = 'transparent'
const TITLE_COLOR = 'E53935'
const TEXT_COLOR  = 'F0F4FF'
const ICON_COLOR  = 'E53935'
const BORDER_COLOR = '1E2D47'
const BG_COLOR = '0D1526'

const statCards = [
  {
    src: `${BASE}?username=${USERNAME}&show_icons=true&theme=${THEME}&title_color=${TITLE_COLOR}&text_color=${TEXT_COLOR}&icon_color=${ICON_COLOR}&border_color=${BORDER_COLOR}&bg_color=${BG_COLOR}&hide_border=false&count_private=true&rank_icon=github&include_all_commits=true`,
    alt: 'GitHub Stats',
    wide: false,
  },
  {
    src: `${BASE}/top-langs/?username=${USERNAME}&layout=compact&theme=${THEME}&title_color=${TITLE_COLOR}&text_color=${TEXT_COLOR}&icon_color=${ICON_COLOR}&border_color=${BORDER_COLOR}&bg_color=${BG_COLOR}&langs_count=8`,
    alt: 'Top Languages',
    wide: false,
  },
  {
    src: `https://github-readme-activity-graph.vercel.app/graph?username=${USERNAME}&bg_color=0D1526&color=F0F4FF&line=E53935&point=FF5252&area_color=E53935&area=true&hide_border=false&custom_title=Contribution%20Activity`,
    alt: 'Contribution Activity Graph',
    wide: true,
  },
]

onMounted(() => {
  gsap.to(headerRef.value, {
    opacity: 1, y: 0, duration: 0.8, ease: 'power3.out',
    scrollTrigger: { trigger: headerRef.value, start: 'top 85%' }
  })

  cardRefs.value.forEach((el, i) => {
    gsap.to(el, {
      opacity: 1, y: 0, duration: 0.7, delay: i * 0.12, ease: 'power3.out',
      scrollTrigger: { trigger: el, start: 'top 90%' }
    })
  })

  gsap.to(linkRef.value, {
    opacity: 1, y: 0, duration: 0.7, ease: 'power3.out',
    scrollTrigger: { trigger: linkRef.value, start: 'top 92%' }
  })
})
</script>

<style scoped lang="scss">
.github-stats {
  background: var(--bg-secondary);
}

.github-stats__label {
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  margin-bottom: 12px;
}

.github-stats__header {
  margin-bottom: 56px;
}

.github-stats__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 32px;

  @media (max-width: 600px) {
    grid-template-columns: 1fr;
  }
}

.github-stats__card {
  background: var(--bg-primary);
  border: 1px solid rgba(229, 57, 53, 0.12);
  border-radius: 16px;
  padding: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: border-color 0.25s, box-shadow 0.25s;
  overflow: hidden;

  &:hover {
    border-color: rgba(229, 57, 53, 0.35);
    box-shadow: 0 0 24px rgba(229, 57, 53, 0.12);
  }

  &--wide {
    grid-column: 1 / -1;
  }
}

.github-stats__img {
  width: 100%;
  height: auto;
  display: block;
}

.github-stats__link {
  text-align: center;
}
</style>
