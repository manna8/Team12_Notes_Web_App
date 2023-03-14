import { createApp } from 'vue';
import { createStore } from 'vuex';
import BootstrapVue from "bootstrap-vue-next";
import { createRouter, createWebHistory} from "vue-router";
// import Vue3Toastify from 'vue3-toastify';

import 'bootstrap/dist/css/bootstrap.css'
import '../public/css/main.css';

import App from '@/App.vue'
import Registration from "@/components/Registration.vue";
import LoginComponent from "@/components/LoginComponent.vue";
import Notes from "@/components/Notes.vue";

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/register', component: Registration },
        { path: '/', component: LoginComponent },
        { path: '/notes', component: Notes }
    ]
});

const store = createStore({
    state() {
        return {
            loggedIn: 0
        };
    },
    mutations: {
        login (state) {
            state.loggedIn = 1;
        }
    }
});

const app = createApp(App).use(BootstrapVue);

app.use(store);
// app.use(Vue3Toastify);
app.use(router);

app.mount('#app');




