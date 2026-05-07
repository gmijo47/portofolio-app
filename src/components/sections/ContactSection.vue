<template>
  <section id="contact" class="section contact">
    <div class="contact__bg-accent"></div>
    <div class="contact__bg-accent-2"></div>

    <div class="container">
      <div ref="headerRef" class="contact__header reveal-hidden">
        <p class="mono text-accent contact__label">// contact</p>
        <h2 class="section-title">Get In Touch<span class="accent-dot">.</span></h2>
        <p class="section-subtitle">
          Have a project in mind, want to collaborate, or just say hi?
          I'm always open to new opportunities.
        </p>
      </div>

      <!-- Centered form card -->
      <div ref="formRef" class="contact__card">
        <form class="contact__form" @submit.prevent="onSubmit">
          <!-- Name + Email side by side -->
          <div class="contact__form-row">
            <div class="contact__form-field">
              <label class="contact__field-label" for="cf-name">Your Name</label>
              <input
                id="cf-name"
                v-model="form.name"
                type="text"
                class="contact__input"
                placeholder="John Doe"
                required
                autocomplete="name"
              />
            </div>
            <div class="contact__form-field">
              <label class="contact__field-label" for="cf-email">Email</label>
              <input
                id="cf-email"
                v-model="form.email"
                type="email"
                class="contact__input"
                placeholder="john@example.com"
                required
                autocomplete="email"
              />
            </div>
          </div>

          <!-- Message -->
          <div class="contact__form-field">
            <label class="contact__field-label" for="cf-msg">Message</label>
            <textarea
              id="cf-msg"
              v-model="form.message"
              class="contact__input contact__textarea"
              placeholder="Your message..."
              rows="5"
              required
            ></textarea>
          </div>

          <v-btn
            type="submit"
            color="primary"
            size="large"
            block
            :loading="sending"
            class="contact__submit"
          >
            <v-icon start>mdi-send</v-icon>
            Send Message
          </v-btn>
        </form>

        <!-- Social pills -->
        <div class="contact__social-pills">
          <a
            v-for="link in socialLinks"
            :key="link.label"
            :href="link.href"
            :target="link.external ? '_blank' : undefined"
            :rel="link.external ? 'noopener noreferrer' : undefined"
            class="contact__social-pill"
          >
            <v-icon size="16" color="primary">{{ link.icon }}</v-icon>
            {{ link.label }}
          </a>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="contact__footer">
      <div class="container contact__footer-inner">
        <p class="contact__footer-copy">
          Mijo Galić © {{ year }}&nbsp;·&nbsp;
          <span class="mono text-accent">galic.dev</span>
        </p>
        <div class="contact__footer-links">
          <a href="https://github.com/gmijo47" target="_blank" rel="noopener" class="contact__footer-link">
            <v-icon size="20">mdi-github</v-icon>
          </a>
          <a href="https://www.linkedin.com/in/galić-mijo-0145241bb/" target="_blank" rel="noopener" class="contact__footer-link">
            <v-icon size="20">mdi-linkedin</v-icon>
          </a>
          <a href="mailto:gmijo47@gmail.com" class="contact__footer-link">
            <v-icon size="20">mdi-email</v-icon>
          </a>
        </div>
      </div>
    </footer>
  </section>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

const headerRef = ref(null)
const formRef   = ref(null)
const sending   = ref(false)
const year = new Date().getFullYear()

const form = reactive({ name: '', email: '', message: '' })

const socialLinks = [
  { label: 'GitHub',   icon: 'mdi-github',   href: 'https://github.com/gmijo47', external: true },
  { label: 'LinkedIn', icon: 'mdi-linkedin',  href: 'https://www.linkedin.com/in/galić-mijo-0145241bb/', external: true },
  { label: 'Email',    icon: 'mdi-email',     href: 'mailto:gmijo47@gmail.com', external: false },
]

function onSubmit() {
  const subject = encodeURIComponent(`Portfolio contact from ${form.name}`)
  const body    = encodeURIComponent(`Name: ${form.name}\nEmail: ${form.email}\n\n${form.message}`)
  window.location.href = `mailto:gmijo47@gmail.com?subject=${subject}&body=${body}`
}

onMounted(() => {
  gsap.to(headerRef.value, {
    opacity: 1, y: 0, duration: 0.9, ease: 'power3.out',
    scrollTrigger: { trigger: headerRef.value, start: 'top 85%' },
  })
  gsap.from(formRef.value, {
    opacity: 0, y: 80, scale: 0.96,
    duration: 1.1, ease: 'back.out(1.7)',
    scrollTrigger: { trigger: formRef.value, start: 'top 88%' },
  })
})
</script>

<style scoped lang="scss">
.contact {
  background: var(--bg-primary);
  position: relative;
  overflow: hidden;
  padding-bottom: 0;
}

/* ── Ambient blobs ──────────────────────────────────────────────── */
.contact__bg-accent {
  position: absolute;
  bottom: -300px;
  left: -200px;
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(229, 57, 53, 0.07) 0%, transparent 70%);
  pointer-events: none;
}

.contact__bg-accent-2 {
  position: absolute;
  top: -200px;
  right: -150px;
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(68, 138, 255, 0.06) 0%, transparent 70%);
  pointer-events: none;
}

/* ── Header ─────────────────────────────────────────────────────── */
.contact__label {
  font-size: 0.9rem;
  letter-spacing: 0.1em;
  margin-bottom: 12px;
}

.contact__header {
  margin-bottom: 60px;
  text-align: center;
}

/* ── Centered card ──────────────────────────────────────────────── */
.contact__card {
  max-width: 660px;
  margin: 0 auto;
  background: var(--bg-secondary);
  border: 1px solid rgba(229, 57, 53, 0.14);
  border-radius: 24px;
  padding: 44px;

  @media (max-width: 600px) {
    padding: 28px 20px;
  }
}

/* ── Form ───────────────────────────────────────────────────────── */
.contact__form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.contact__form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;

  @media (max-width: 560px) {
    grid-template-columns: 1fr;
  }
}

.contact__form-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.contact__field-label {
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--text-muted);
  letter-spacing: 0.04em;
}

.contact__input {
  background: var(--bg-primary);
  border: 1px solid rgba(229, 57, 53, 0.15);
  border-radius: 10px;
  padding: 12px 16px;
  color: var(--text-primary);
  font-family: 'Space Grotesk', sans-serif;
  font-size: 0.95rem;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
  width: 100%;

  &::placeholder { color: var(--text-muted); opacity: 0.6; }

  &:focus {
    border-color: rgba(229, 57, 53, 0.5);
    box-shadow: 0 0 12px rgba(229, 57, 53, 0.15);
  }
}

.contact__textarea {
  resize: vertical;
  min-height: 130px;
}

.contact__submit {
  font-weight: 700;
  letter-spacing: 0.03em;
  margin-top: 4px;
  box-shadow: 0 0 20px rgba(229, 57, 53, 0.3);

  &:hover {
    box-shadow: 0 0 36px rgba(229, 57, 53, 0.55);
  }
}

/* ── Social pills ───────────────────────────────────────────────── */
.contact__social-pills {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 28px;
  flex-wrap: wrap;
}

.contact__social-pill {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 8px 18px;
  border-radius: 999px;
  border: 1px solid rgba(229, 57, 53, 0.18);
  color: var(--text-muted);
  text-decoration: none;
  font-size: 0.85rem;
  font-weight: 500;
  transition: color 0.2s, border-color 0.25s, background 0.2s, transform 0.2s;

  &:hover {
    color: var(--text-primary);
    border-color: rgba(229, 57, 53, 0.5);
    background: rgba(229, 57, 53, 0.07);
    transform: translateY(-2px);
  }
}

/* ── Footer ─────────────────────────────────────────────────────── */
.contact__footer {
  margin-top: 100px;
  border-top: 1px solid rgba(229, 57, 53, 0.12);
  padding: 28px 0;
}

.contact__footer-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 16px;
}

.contact__footer-copy {
  font-size: 0.875rem;
  color: var(--text-muted);
}

.contact__footer-links {
  display: flex;
  gap: 16px;
}

.contact__footer-link {
  color: var(--text-muted);
  text-decoration: none;
  transition: color 0.2s;
  &:hover { color: var(--accent); }
}
</style>
