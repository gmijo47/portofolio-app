<template>
  <v-app>
    <NavBar />
    <v-main>
      <HeroSection />
      <AboutSection />
      <ServicesSection />
      <SkillsSection />
      <ProjectsSection />
      <GitHubStatsSection />
      <ContactSection />
    </v-main>
  </v-app>
</template>

<script setup>
import NavBar            from '@/components/NavBar.vue'
import HeroSection       from '@/components/sections/HeroSection.vue'
import AboutSection      from '@/components/sections/AboutSection.vue'
import ServicesSection   from '@/components/sections/ServicesSection.vue'
import SkillsSection     from '@/components/sections/SkillsSection.vue'
import ProjectsSection   from '@/components/sections/ProjectsSection.vue'
import GitHubStatsSection from '@/components/sections/GitHubStatsSection.vue'
import ContactSection    from '@/components/sections/ContactSection.vue'
</script>

<style lang="scss">
.v-main {
  padding: 0 !important;
}

.v-main__wrap {
  padding: 0 !important;
}
</style>
