<template id="app">
  <nav class="navbar navbar-expand navbar-light bg-light border border-warning">
    <router-link class="navbar-brand" to="/">
      <h3 class="font-weight-bold">MindNote</h3>
    </router-link>
    <div class="w-100">
      <ul class="navbar-nav">
        <li class="nav-item">
          <router-link class="nav-link" to="/notes">Notes</router-link>
        </li>
        <li class="nav-item">
          <router-link class="nav-link" to="/friends">Friends</router-link>
        </li>
        <li class="nav-item">
          <router-link class="nav-link" to="/profile">Profile</router-link>
        </li>
      </ul>
    </div>

    <div class="w-200" v-if="isLoggedIn">
      <ul class="navbar-nav">
        <li class="nav-item" @click="logout">
          <button type="button" class="btn btn-outline-warning">
            <router-link class="nav-link" to="/">Logout</router-link>
          </button>
        </li>
      </ul>
    </div>
  </nav>

</template>

<script>

export default {
  name: "MainMenu",
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
      this.isLoggedIn = this.loggedIn();
    }
  }
}
</script>

<style scoped>
#app {
  background-image: url("@/assets/background4.png");
}

</style>