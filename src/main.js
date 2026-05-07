import { createApp } from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import '@mdi/font/css/materialdesignicons.css'
import './assets/styles/main.scss'

const app = createApp(App)
app.use(vuetify)
app.mount('#app')
