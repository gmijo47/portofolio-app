<template>
  <section id="projects" class="section projects">
    <div class="container">
      <!-- Header -->
      <div ref="headerRef" class="projects__header reveal-hidden">
        <p class="mono text-accent projects__label">// projects</p>
        <h2 class="section-title">What I've Built<span class="accent-dot">.</span></h2>
        <p class="section-subtitle">
          A selection of projects spanning IoT, ML, backend and mobile — not everything is shown here.
          Full history at <a href="https://github.com/gmijo47" target="_blank" rel="noopener" class="text-accent">github.com/gmijo47</a>.
        </p>
      </div>

      <!-- Category filter tabs -->
      <div ref="tabsRef" class="projects__tabs reveal-hidden">
        <button
          v-for="tab in tabs"
          :key="tab.value"
          class="projects__tab"
          :class="{ active: activeTab === tab.value }"
          @click="setTab(tab.value)"
        >
          <v-icon size="15" class="mr-1">{{ tab.icon }}</v-icon>
          {{ tab.label }}
          <span class="projects__tab-count">{{ getCount(tab.value) }}</span>
        </button>
      </div>

      <!-- Projects grid -->
      <TransitionGroup name="project-list" tag="div" class="projects__grid">
        <div
          v-for="project in filteredProjects"
          :key="project.id"
          class="project-card"
          :class="{
            'project-card--research': project.category === 'research',
            'project-card--professional': project.category === 'professional',
          }"
          @mousemove="onMouseMove($event, project.id)"
          @mouseleave="onMouseLeave(project.id)"
          :ref="el => { if (el) cardMap[project.id] = el }"
        >
          <!-- Category badge -->
          <div class="project-card__badge" :class="`badge--${project.category}`">
            <v-icon size="11">{{ categoryIcon(project.category) }}</v-icon>
            {{ categoryLabel(project.category) }}
          </div>

          <div class="project-card__top">
            <div class="project-card__icon-wrap">
              <v-icon size="28" color="primary">{{ project.icon }}</v-icon>
            </div>
            <div class="project-card__actions">
              <a
                v-if="project.github"
                :href="project.github"
                target="_blank"
                rel="noopener noreferrer"
                class="project-card__action"
                aria-label="View on GitHub"
              >
                <v-icon size="20">mdi-github</v-icon>
              </a>
              <a
                v-if="project.link"
                :href="project.link"
                target="_blank"
                rel="noopener noreferrer"
                class="project-card__action"
                aria-label="Live project"
              >
                <v-icon size="20">mdi-open-in-new</v-icon>
              </a>
            </div>
          </div>

          <p class="project-card__period mono">{{ project.period }}</p>
          <h3 class="project-card__title">{{ project.title }}</h3>
          <p class="project-card__desc">{{ project.description }}</p>

          <div class="project-card__tags">
            <v-chip
              v-for="tag in project.tags"
              :key="tag"
              size="x-small"
              variant="tonal"
              color="primary"
              class="mr-1 mb-1"
            >{{ tag }}</v-chip>
          </div>
        </div>
      </TransitionGroup>

      <div ref="ctaRef" class="projects__cta reveal-hidden" style="text-align: center">
        <v-btn
          variant="outlined"
          color="primary"
          size="large"
          href="https://github.com/gmijo47"
          target="_blank"
          rel="noopener"
        >
          <v-icon start>mdi-github</v-icon>
          All Repositories
        </v-btn>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, reactive, onMounted, nextTick, watch } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { projects } from '@/data/projects.js'

gsap.registerPlugin(ScrollTrigger)

const headerRef = ref(null)
const tabsRef   = ref(null)
const ctaRef    = ref(null)
const cardMap   = reactive({})
const activeTab = ref('all')

const tabs = [
  { value: 'all',          label: 'All',          icon: 'mdi-view-grid-outline' },
  { value: 'research',     label: 'Research',     icon: 'mdi-flask-outline' },
  { value: 'professional', label: 'Professional', icon: 'mdi-briefcase-outline' },
  { value: 'personal',     label: 'Personal',     icon: 'mdi-account-outline' },
]

function getCount(tab) {
  if (tab === 'all') return projects.length
  return projects.filter(p => p.category === tab).length
}

function setTab(val) {
  activeTab.value = val
  nextTick(() => animateCards())
}

const filteredProjects = computed(() => {
  if (activeTab.value === 'all') return projects
  return projects.filter(p => p.category === activeTab.value)
})

function categoryIcon(cat) {
  const map = { research: 'mdi-flask', professional: 'mdi-briefcase', personal: 'mdi-account' }
  return map[cat] || 'mdi-circle'
}
function categoryLabel(cat) {
  const map = { research: 'Research', professional: 'Professional', personal: 'Personal' }
  return map[cat] || cat
}

function animateCards() {
  const cards = document.querySelectorAll('.project-card')
  gsap.fromTo(cards,
    { opacity: 0, y: 30, scale: 0.97 },
    { opacity: 1, y: 0, scale: 1, duration: 0.5, stagger: 0.07, ease: 'power3.out' }
  )
}

onMounted(() => {
  gsap.to(headerRef.value, {
    opacity: 1, y: 0, duration: 0.8, ease: 'power3.out',
    scrollTrigger: { trigger: headerRef.value, start: 'top 85%' }
  })
  gsap.to(tabsRef.value, {
    opacity: 1, y: 0, duration: 0.6, delay: 0.1, ease: 'power3.out',
    scrollTrigger: { trigger: tabsRef.value, start: 'top 88%' }
  })
  gsap.to(ctaRef.value, {
    opacity: 1, y: 0, duration: 0.6, ease: 'power3.out',
    scrollTrigger: { trigger: ctaRef.value, start: 'top 92%' }
  })
  ScrollTrigger.create({
    trigger: '.projects__grid',
    start: 'top 85%',
    once: true,
    onEnter: () => animateCards(),
  })
})

function onMouseMove(e, id) {
  const card = cardMap[id]
  if (!card) return
  const rect = card.getBoundingClientRect()
  const x = (e.clientX - rect.left) / rect.width  - 0.5
  const y = (e.clientY - rect.top)  / rect.height - 0.5
  gsap.to(card, {
    rotateY: x * 10, rotateX: -y * 10,
    boxShadow: `${-x * 14}px ${y * 14}px 32px rgba(229,57,53,0.22)`,
    duration: 0.25, ease: 'power2.out', transformPerspective: 900,
  })
}

function onMouseLeave(id) {
  const card = cardMap[id]
  if (!card) return
  gsap.to(card, {
    rotateY: 0, rotateX: 0, boxShadow: '0 0 0 rgba(0,0,0,0)',
    duration: 0.45, ease: 'power3.out',
  })
}
</script>

<style scoped lang="scss">
.projects {
  background: var(--bg-primary);
}

.projects__label {
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  margin-bottom: 12px;
}

.projects__header {
  margin-bottom: 36px;
  text-align: center;
}

/* ─── Filter tabs ─────────────────────────────────────────────────── */
.projects__tabs {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-bottom: 44px;
  justify-content: center;
}

.projects__tab {
  display: flex;
  align-items: center;
  gap: 5px;
  background: var(--bg-secondary);
  border: 1px solid rgba(229, 57, 53, 0.15);
  border-radius: 10px;
  padding: 8px 16px;
  color: var(--text-muted);
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  font-family: 'Space Grotesk', sans-serif;
  transition: all 0.2s ease;

  &:hover {
    border-color: rgba(229, 57, 53, 0.4);
    color: var(--text-primary);
    background: rgba(229, 57, 53, 0.05);
  }

  &.active {
    background: rgba(229, 57, 53, 0.12);
    border-color: rgba(229, 57, 53, 0.55);
    color: var(--accent);
  }
}

.projects__tab-count {
  background: rgba(229, 57, 53, 0.15);
  color: var(--accent);
  border-radius: 20px;
  padding: 1px 8px;
  font-size: 0.72rem;
  font-family: 'JetBrains Mono', monospace;
  margin-left: 4px;
}

/* ─── Grid ────────────────────────────────────────────────────────── */
.projects__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
  gap: 22px;
  margin-bottom: 48px;
  min-height: 200px;

  @media (max-width: 600px) {
    grid-template-columns: 1fr;
  }
}

/* ─── TransitionGroup ─────────────────────────────────────────────── */
.project-list-enter-active,
.project-list-leave-active {
  transition: all 0.3s ease;
}
.project-list-enter-from,
.project-list-leave-to {
  opacity: 0;
  transform: translateY(18px) scale(0.97);
}
.project-list-move {
  transition: transform 0.3s ease;
}

/* ─── Card ────────────────────────────────────────────────────────── */
.project-card {
  background: var(--bg-secondary);
  border: 1px solid rgba(229, 57, 53, 0.12);
  border-radius: 20px;
  padding: 26px;
  cursor: default;
  transform-style: preserve-3d;
  position: relative;
  display: flex;
  flex-direction: column;
  transition: border-color 0.25s;

  &:hover {
    border-color: rgba(229, 57, 53, 0.38);
  }

  &--research {
    background: linear-gradient(145deg, var(--bg-secondary) 60%, rgba(229, 57, 53, 0.04) 100%);
  }
}

/* ─── Badge ───────────────────────────────────────────────────────── */
.project-card__badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 0.68rem;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  padding: 3px 10px;
  border-radius: 20px;
  margin-bottom: 14px;
  width: fit-content;

  &.badge--research {
    background: rgba(229, 57, 53, 0.12);
    color: var(--accent);
    border: 1px solid rgba(229, 57, 53, 0.25);
  }

  &.badge--professional {
    background: rgba(21, 101, 192, 0.12);
    color: #448AFF;
    border: 1px solid rgba(21, 101, 192, 0.3);
  }

  &.badge--personal {
    background: rgba(105, 240, 174, 0.1);
    color: #69F0AE;
    border: 1px solid rgba(105, 240, 174, 0.2);
  }
}

.project-card__top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.project-card__icon-wrap {
  width: 50px;
  height: 50px;
  background: rgba(229, 57, 53, 0.08);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.project-card__actions {
  display: flex;
  gap: 12px;
}

.project-card__action {
  color: var(--text-muted);
  text-decoration: none;
  transition: color 0.2s;
  &:hover { color: var(--accent); }
}

.project-card__period {
  font-size: 0.72rem;
  color: var(--accent);
  opacity: 0.75;
  margin-bottom: 6px;
}

.project-card__title {
  font-size: 1.15rem;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 10px;
  line-height: 1.3;
}

.project-card__desc {
  color: var(--text-muted);
  font-size: 0.875rem;
  line-height: 1.72;
  margin-bottom: 18px;
  flex-grow: 1;
}

.project-card__tags {
  display: flex;
  flex-wrap: wrap;
  margin-top: auto;
}

/* ─── CTA ─────────────────────────────────────────────────────────── */
.projects__cta {
  text-align: center;
  margin-top: 8px;
}
</style>

