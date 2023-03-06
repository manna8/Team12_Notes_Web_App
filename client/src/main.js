import { createApp } from 'vue';
import BootstrapVue3 from "bootstrap-vue-3";
import { createRouter, createWebHistory} from "vue-router";
// import Toasted from 'vue-toasted';

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-3/dist/bootstrap-vue-3.css'
import '../public/css/main.css';

import App from '@/App.vue'
import Registration from "@/components/Registration.vue";
import LoginComponent from "@/components/LoginComponent.vue";
import Notes from "@/components/Notes.vue";

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/register', component: Registration },
        { path: '/login', component: LoginComponent },
        { path: '/notes', component: Notes }
    ]
});

const app = createApp(App).use(BootstrapVue3);

// app.use(Toasted);

app.use(router);

app.mount('#app');





