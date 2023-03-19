<template id="app">
  <nav class="navbar navbar-expand navbar-light bg-light border border-warning">
    <router-link class="navbar-brand" to="/">
      <h3 class="font-weight-bold">MindNote</h3>
    </router-link>
    <div class="w-100">
      <div  v-if="isLogged">
        <ul class="navbar-nav">
          <li class="nav-item">
            <div class="dropdown">
              <button class="btn btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                Notes
              </button>
              <ul class="dropdown-menu">
                <li><router-link class="nav-link dropdown-item" to="/notes">Notes</router-link></li>
                <li><router-link class="nav-link dropdown-item" to="/collections">Collections</router-link></li>
              </ul>
            </div>
          </li>

          <li class="nav-item">
            <router-link class="nav-link active" to="/friends">Friends</router-link>
          </li>

          <li class="nav-item">
            <router-link class="nav-link active" to="/profile">Profile</router-link>
          </li>
        </ul>
      </div>

    </div>

    <div class="w-200">
      <ul class="navbar-nav">
        <li class="nav-item" v-if="isLogged">
          <button type="button" class="btn btn-outline-warning"  @click="logout">
            <router-link class="nav-link" to="/">Logout</router-link>
          </button>
        </li>
        <li  class="nav-item" v-else>
          <button type="button" class="btn btn-outline-warning">
            <router-link class="nav-link" to="/login">Login</router-link>
          </button>
        </li>
      </ul>
    </div>
  </nav>

</template>

<script>

import axios from "axios";
import config from "../../config/config";

export default {
  name: "MainMenu",

  data() {
    return {
      isLoggedIn: false
    }
  },
  methods: {
    logout() {
      axios.delete(config.logoutURL, {withCredentials: true})
          .then(() => this.$router.push({path: '/'}))
          .catch(err => console.log(err.message));
      this.$store.commit('logout');
      console.log(this.$store.state.loggedIn);
      sessionStorage.clear();
    },
  },
  computed: {
    isLogged() {
      return this.$store.state.loggedIn;
    }
  }
}
</script>

<style scoped>
#app {
  background-image: url("@/assets/background4.png");
}

</style>