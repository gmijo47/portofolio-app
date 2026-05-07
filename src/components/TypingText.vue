<template>
  <span ref="el" class="typing-text mono"></span>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import Typed from 'typed.js'

const props = defineProps({
  strings: { type: Array, required: true },
  typeSpeed: { type: Number, default: 60 },
  backSpeed: { type: Number, default: 40 },
  backDelay: { type: Number, default: 1800 },
  loop: { type: Boolean, default: true },
})

const el = ref(null)
let typed = null

onMounted(() => {
  typed = new Typed(el.value, {
    strings: props.strings,
    typeSpeed: props.typeSpeed,
    backSpeed: props.backSpeed,
    backDelay: props.backDelay,
    loop: props.loop,
    cursorChar: '|',
  })
})

onBeforeUnmount(() => {
  typed?.destroy()
})
</script>

<style scoped>
.typing-text {
  color: var(--accent);
  font-size: inherit;
  font-weight: 600;
}
</style>
