import { createApp } from 'vue';
import { createStore } from 'vuex';
import VueCookies from 'vue-cookies'
import BootstrapVue from "bootstrap-vue-next";
import { createRouter, createWebHistory} from "vue-router";
import axios from "axios";

import 'bootstrap/dist/css/bootstrap.css'
import '../public/css/main.css';

import App from '@/App.vue'
import Registration from "@/components/Registration.vue";
import LoginComponent from "@/components/LoginComponent.vue";
import Notes from "@/components/Notes.vue";
import Friends from "@/components/Friends.vue";
import Profile from "@/components/Profile.vue";
import AddNote from "@/components/AddNote.vue";
import Home from "@/components/Home.vue";
import Collections from "@/components/Collections.vue";

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/register', component: Registration },
        { path: '/login', component: LoginComponent },
        { path: '/notes', component: Notes },
        { path: '/friends', component: Friends },
        { path: '/profile', component: Profile },
        { path: '/createNote', component: AddNote},
        { path: '/collections', component: Collections},
        { path: '/', component: Home},
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

const instance = axios.create({
    withCredentials: true
});

instance.get("http://127.0.0.1:3000/login")
    .then(response => console.log(response.data));

const app = createApp(App).use(BootstrapVue);

app.use(store);
app.use(router);
app.use(VueCookies);

app.mixin({
    methods: {
        handleError: function ({message, response}, redirectURL) {
            if (response.status === 401) {
                this.$cookies.remove('jwt');
                this.$router.push({path: redirectURL});
            } else {
                console.error(message);
            }
        },
        loggedIn: function () {
            return this.$cookies.get('jwt') !== null;
        }
    }
})

app.mount('#app');
// import Vue from 'vue';
// import App from './App.vue';
// import router from './router';
//
// new Vue({
//     router,
//     render: h => h(App)
// }).$mount('#app');





