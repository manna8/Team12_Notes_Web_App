<template id="login">
 <div id="login">

  <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 400px">
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
// import TokenDataService from "@/services/TokenDataService";

import axios from "axios";
import config from "../../config/config";

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
        }, {withCredentials: true}).then(res => console.log(res))
            .then(response => localStorage.setItem('jwtToken', response.data.token))
            .then(() => this.$router.push({path: '/notes'}))
            .then(() => console.log(localStorage.getItem('jwtToken')))
        .catch(err => console.log(err.response.data ? err.response.data : err.message));
      }
    }
  }
}
</script>

<style scoped>

</style>