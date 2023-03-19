<template id="login">
 <div id="login">

  <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 400px" @click.prevent>
    <h2 class="text-center text-warning">Login!</h2>
    <div class="mb-3 d-flex flex-column align-items-start">
      <label for="username">Username</label>
      <input type="text" class="form-control" v-model="input.username" placeholder="Enter username">
    </div>

    <div class="mb-3 d-flex flex-column align-items-start">
      <label for="password">Password</label>
      <input type="password" class="form-control" v-model="input.password" placeholder="Enter password">
    </div>

    <p>Don't have an account?
      <router-link to="register" class="link-warning">Sign up!</router-link>
    </p>

    <div class="text-center">
      <button type="submit" class="btn btn-outline-dark mt-auto" @click="login">Login!</button>
    </div>

  </form>

 </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";
import Cookies from 'js-cookie';

export default {
  name: "login",
  data() {
    return {
      input: {
        username: "",
        password: ""
      }
    }
  },
  methods: {
    login() {
      if (this.input.password !== "" && this.input.username !== "") {

        axios.post(config.loginURL, {
          "email": this.input.username,
          "password": this.input.password
        }, {withCredentials: true})
            .then(() => this.$router.push({path: '/notes'}))
            .catch(err => console.log(err.message));

        const myCookie = Cookies.get('jwt');
        console.log(myCookie);
        this.$store.commit('login');
        console.log(this.$store.state.loggedIn);
      }
    }
  }
}
</script>

<style scoped>

</style>