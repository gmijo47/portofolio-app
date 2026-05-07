<template>
  <nav class="navbar" :class="{ 'navbar--scrolled': scrolled }">
    <div class="container navbar__inner">
      <!-- Logo -->
      <a href="#hero" class="navbar__logo" @click.prevent="scrollTo('hero')">
        <span class="logo-bracket">&lt;</span>
        <span class="logo-name">MG</span>
        <span class="logo-bracket"> /&gt;</span>
      </a>

      <!-- Desktop nav links -->
      <ul class="navbar__links" :class="{ 'navbar__links--open': menuOpen }">
        <li v-for="item in navItems" :key="item.id">
          <a
            :href="`#${item.id}`"
            class="navbar__link"
            :class="{ active: activeSection === item.id }"
            @click.prevent="scrollTo(item.id); menuOpen = false"
          >{{ item.label }}</a>
        </li>
      </ul>

      <!-- Mobile hamburger -->
      <button class="hamburger" :class="{ open: menuOpen }" @click="menuOpen = !menuOpen" aria-label="Toggle menu">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

const scrolled = ref(false)
const menuOpen = ref(false)
const activeSection = ref('hero')

const navItems = [
  { id: 'hero',     label: 'Home' },
  { id: 'about',    label: 'About' },
  { id: 'services', label: 'Services' },
  { id: 'skills',   label: 'Skills' },
  { id: 'projects', label: 'Projects' },
  { id: 'github',   label: 'GitHub' },
  { id: 'contact',  label: 'Contact' },
]

function scrollTo(id) {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
}

function onScroll() {
  scrolled.value = window.scrollY > 60

  // Active section detection
  for (const item of [...navItems].reverse()) {
    const el = document.getElementById(item.id)
    if (el && window.scrollY >= el.offsetTop - 120) {
      activeSection.value = item.id
      break
    }
  }
}

onMounted(() => window.addEventListener('scroll', onScroll, { passive: true }))
onBeforeUnmount(() => window.removeEventListener('scroll', onScroll))
</script>

<style scoped lang="scss">
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  padding: 20px 0;
  transition: background 0.35s ease, padding 0.35s ease, backdrop-filter 0.35s ease;

  &--scrolled {
    padding: 12px 0;
    background: rgba(7, 11, 20, 0.85);
    backdrop-filter: blur(16px);
    border-bottom: 1px solid rgba(229, 57, 53, 0.15);
  }
}

.navbar__inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.navbar__logo {
  font-family: 'JetBrains Mono', monospace;
  font-size: 1.25rem;
  font-weight: 700;
  text-decoration: none;
  color: var(--text-primary);
  transition: color 0.2s;

  .logo-bracket { color: var(--accent); }
  .logo-name    { color: var(--text-primary); }

  &:hover .logo-name { color: var(--accent); }
}

.navbar__links {
  display: flex;
  list-style: none;
  gap: 32px;

  @media (max-width: 768px) {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(7, 11, 20, 0.97);
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 40px;

    &--open { display: flex; }
  }
}

.navbar__link {
  text-decoration: none;
  color: var(--text-muted);
  font-weight: 500;
  font-size: 0.95rem;
  letter-spacing: 0.02em;
  transition: color 0.2s;
  position: relative;

  &::after {
    content: '';
    position: absolute;
    bottom: -4px;
    left: 0;
    width: 0;
    height: 2px;
    background: var(--accent);
    border-radius: 1px;
    transition: width 0.25s ease;
  }

  &:hover, &.active {
    color: var(--text-primary);
    &::after { width: 100%; }
  }

  &.active { color: var(--accent); }

  @media (max-width: 768px) {
    font-size: 1.5rem;
  }
}

.hamburger {
  display: none;
  flex-direction: column;
  gap: 6px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  z-index: 1001;

  span {
    display: block;
    width: 26px;
    height: 2px;
    background: var(--text-primary);
    border-radius: 2px;
    transition: transform 0.3s ease, opacity 0.3s ease;
  }

  &.open {
    span:nth-child(1) { transform: translateY(8px) rotate(45deg); }
    span:nth-child(2) { opacity: 0; }
    span:nth-child(3) { transform: translateY(-8px) rotate(-45deg); }
  }

  @media (max-width: 768px) { display: flex; }
}
</style>
