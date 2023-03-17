import { createApp } from 'vue';
import { createStore } from 'vuex';
// import Cookies from 'js-cookie';
import BootstrapVue from "bootstrap-vue-next";
import { createRouter, createWebHistory} from "vue-router";

import 'bootstrap/dist/css/bootstrap.css'
import '../public/css/main.css';

import App from '@/App.vue'
import Registration from "@/components/Registration.vue";
import LoginComponent from "@/components/LoginComponent.vue";
import Notes from "@/components/Notes.vue";
import Friends from "@/components/Friends.vue";
import Profile from "@/components/Profile.vue";

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/register', component: Registration },
        { path: '/', component: LoginComponent },
        { path: '/notes', component: Notes },
        { path: '/friends', component: Friends },
        { path: '/profile', component: Profile },
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
app.use(router);

app.mount('#app');
// import Vue from 'vue';
// import App from './App.vue';
// import router from './router';
//
// new Vue({
//     router,
//     render: h => h(App)
// }).$mount('#app');





