<template>
  <div class="glitch-wrapper" :class="{ 'glitch-auto': auto }">
    <span
      class="glitch-text"
      :data-text="text"
      :style="textStyle"
    >{{ text }}</span>
  </div>
</template>

<script setup>
const props = defineProps({
  text: { type: String, required: true },
  fontSize: { type: String, default: 'inherit' },
  color: { type: String, default: 'inherit' },
  auto: { type: Boolean, default: false },
})

const textStyle = {
  fontSize: props.fontSize,
  color: props.color,
}
</script>
