import Vue from 'vue';
import Router from 'vue-router';

Vue.use(Router);

const router = new Router({
    mode: "history",
    routes: [
        {
            path: "/",
            alias: "/login",
            name: "login",
            component: () => import("./components/Login"),
            beforeEnter: requireAuth
        },
        {
            path: "/users",
            name: "users",
            component: () => import("./components/UsersList")
        },
        {
            path: "/password",
            name: "password",
            component: () => import("./components/Password")
        },
        {
            path: "/events",
            name: "events",
            component: () => import("./components/Events")
        },
        {
            path: "/signup",
            name: "signup",
            component: () => import("./components/Signup")
        },
        {
            path: "/dashboard",
            name: "dashboard",
            component: () => import("./components/Dashboard")
        },
        {
            path: "/wishes",
            name: "wishes",
            component: () => import("./components/Wishes")
        },
        {
            path: "/forgot",
            name: "reset-password",
            component: () => import("./components/ResetPassword")
        }
    ]
});

function requireAuth(to, from, next) {
    if (window.$cookies.get('TOKEN')) {
        next('/dashboard');
    } else {
        next();
    }
}

export default router;