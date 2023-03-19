<template id="app">
  <nav class="navbar navbar-expand navbar-light bg-light border border-warning" :key="menuKey">
    <router-link class="navbar-brand" to="/">
      <h3 class="font-weight-bold">MindNote</h3>
    </router-link>
    <div class="w-100">
      <div  v-if="isLoggedIn">
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
        <li class="nav-item" @click="logout" v-if="isLoggedIn">
          <button type="button" class="btn btn-outline-warning">
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

export default {
  name: "MainMenu",
  props: ['menuKey'],
  data() {
    return {
      isLoggedIn: false
    }
  },
  methods: {
    logout() {
      this.$cookies.remove('TOKEN');
      this.$router.push({path: '/'})
          .then(() => this.$toasted.success('Logged out'))
          .catch(err => this.$toasted.error(err.response.data ? err.response.data : err.message));
    },
  },
  watch: {
    $route() {
      this.$store.commit("loggedIn");
      this.isLoggedIn = this.$store.state.loggedIn;
    }
  }
}
</script>

<style scoped>
#app {
  background-image: url("@/assets/background4.png");
}

</style>