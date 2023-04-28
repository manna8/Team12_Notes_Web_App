<template id="app">
  <nav class="navbar navbar-expand-md navbar-light bg-light border border-warning">
    <div class="container-fluid">

      <router-link class="navbar-brand" to="/">
        <h3 class="font-weight-bold">MindNote</h3>
      </router-link>

      <button v-if="isLogged" class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <button type="button" class="btn btn-outline-warning" v-else>
        <router-link class="nav-link" to="/login">Login</router-link>
      </button>

      <div class="collapse navbar-collapse" id="navbarNav" v-if="isLogged">

        <ul class="navbar-nav me-auto mb-2 mb-md-0">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              Notes
            </a>

            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
              <li><router-link class="dropdown-item" to="/notes">Notes</router-link></li>
              <li><router-link class="dropdown-item" to="/collections">Collections</router-link></li>
            </ul>

          </li>

          <li class="nav-item" v-if="!isAdmin">
            <router-link class="nav-link active" to="/friends">Friends</router-link>
          </li>

          <li class="nav-item" v-else>
            <router-link class="nav-link active" to="/users">Users</router-link>
          </li>

          <li class="nav-item" v-if="isAdmin">
            <router-link class="nav-link active" to="/friendships">Friendships</router-link>
          </li>

          <li class="nav-item" v-if="!isAdmin">
            <router-link class="nav-link active" to="/profile">Profile</router-link>
          </li>
        </ul>

        <ul class="navbar-nav">
          <li class="nav-item">
            <button type="button" class="btn btn-outline-warning" @click="logout" data-bs-toggle="collapse" data-bs-target="#navbarNav">
              <router-link class="nav-link" to="/">Logout</router-link>
            </button>
          </li>
        </ul>
      </div>

    </div>
  </nav>

</template>

<script>

import axios from "axios";
import config from "../../config/config";

export default {
  name: "MainMenu",

  methods: {
    logout() {
      axios.delete(config.logoutURL, {withCredentials: true})
          .then(() => this.$router.push({path: '/'}))
          .catch(err => console.log(err.message));
      this.$store.commit('logout');
      this.$store.commit('removeAdmin');
      console.log(this.$store.state.loggedIn);
      console.log(this.$store.state.admin);
    },
  },

  computed: {
    isLogged() {
      return this.$store.state.loggedIn;
    },
    isAdmin() {
      return this.$store.state.admin;
    }
  }
}
</script>

<style scoped>
#app {
  background-image: url("@/assets/background4.png");
}

</style>