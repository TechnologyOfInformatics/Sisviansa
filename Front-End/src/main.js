import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import axios from 'axios';
import AOS from 'aos';
import 'aos/dist/aos.css'; 
AOS.init();
const app = createApp(App);
app.use(router);

axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
app.config.globalProperties.$http = axios;

app.mount('#app');