<template>
  <div ref="canvasContainer" class="particles-bg"></div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { loadSlim } from '@tsparticles/slim'
import { tsParticles } from '@tsparticles/engine'

const canvasContainer = ref(null)
let container = null

const particlesConfig = {
  background: { color: { value: 'transparent' } },
  fpsLimit: 60,
  interactivity: {
    events: {
      onHover: { enable: true, mode: 'grab' },
      onClick: { enable: true, mode: 'push' },
    },
    modes: {
      grab: { distance: 180, links: { opacity: 0.5 } },
      push: { quantity: 2 },
    }
  },
  particles: {
    color: { value: ['#E53935', '#FF5252', '#1565C0', '#F0F4FF'] },
    links: {
      color: '#E53935',
      distance: 140,
      enable: true,
      opacity: 0.18,
      width: 1,
    },
    move: {
      enable: true,
      speed: 0.8,
      direction: 'none',
      outModes: { default: 'bounce' },
    },
    number: { value: 70, density: { enable: true, area: 900 } },
    opacity: { value: { min: 0.2, max: 0.7 }, animation: { enable: true, speed: 0.5 } },
    shape: { type: 'circle' },
    size: { value: { min: 1, max: 3 } },
  },
  detectRetina: true,
}

onMounted(async () => {
  await loadSlim(tsParticles)
  container = await tsParticles.load({
    id: 'hero-particles',
    element: canvasContainer.value,
    options: particlesConfig,
  })
})

onBeforeUnmount(() => {
  container?.destroy()
})
</script>

<style scoped>
.particles-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.particles-bg :deep(canvas) {
  position: absolute;
  inset: 0;
  pointer-events: all;
}
</style>
