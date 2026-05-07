import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

const galicTheme = {
  dark: true,
  colors: {
    background: '#070B14',
    surface: '#0D1526',
    'surface-variant': '#111E33',
    primary: '#E53935',
    'primary-lighten-1': '#FF5252',
    secondary: '#1565C0',
    accent: '#E53935',
    error: '#FF5252',
    info: '#448AFF',
    success: '#69F0AE',
    warning: '#FFD740',
    'on-background': '#F0F4FF',
    'on-surface': '#F0F4FF',
    'on-primary': '#FFFFFF',
  }
}

export default createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'galicTheme',
    themes: { galicTheme }
  },
  defaults: {
    VBtn: {
      variant: 'flat',
      rounded: 'lg',
    },
    VCard: {
      rounded: 'xl',
    }
  }
})
