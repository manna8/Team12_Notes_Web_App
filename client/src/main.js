import { createApp } from 'vue';
import { createStore } from 'vuex';
import VueCookies from 'vue-cookies'
import { createRouter, createWebHistory} from "vue-router";
import axios from "axios";
import createPersistedState from 'vuex-persistedstate'

import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';

import BootstrapVue from "bootstrap-vue-next";
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
import EditNote from "@/components/EditNote.vue";
import EditCollection from "@/components/EditCollection.vue";
import Users from "@/components/Users.vue";
import Friendships from "@/components/Friendships.vue";

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
        { path: '/collections/:id', component: EditCollection, props: true},
        { path: '/notes/:id', component: EditNote, props: true},
        { path: '/users', component: Users},
        { path: '/friendships', component: Friendships},
        { path: '/', component: Home},
    ]
});

const store = createStore({
    plugins: [createPersistedState()],
    state() {
        return {
            loggedIn: 0,
            admin: 0
        };
    },
    mutations: {
        login(state) {
            state.loggedIn = 1;
        },
        logout(state) {
            state.loggedIn = 0;
        },
        setAdmin(state) {
            state.admin = 1;
        },
        removeAdmin(state) {
            state.admin = 0;
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
app.use(VueSweetalert2);

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






