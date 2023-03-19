<template id="register">
  <div id="register">

    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 500px" @click.prevent>
      <h2 class="text-center text-warning">Register!</h2>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="username">Username</label>
        <input type="text" class="form-control" placeholder="Enter username" v-model="input.username">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="email">Email</label>
        <input type="text" class="form-control" placeholder="Enter email" v-model="input.email">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="password">Password</label>
        <input type="password" class="form-control" placeholder="Enter password" v-model="input.password">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="password">Password</label>
        <input type="password" class="form-control" placeholder="Repeat password" v-model="input.password_v2">
      </div>

      <p>Already have an account?
        <router-link to="/login" class="link-warning">Login!</router-link>
      </p>

      <div class="text-center">
        <button type="submit" class="btn btn-outline-dark" @click="register">Register!</button>
      </div>

    </form>
  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";
export default {
  name: "Registration",

  data() {
    return {
      input: {
        email: "",
        username: "",
        password: "",
        password_v2: ""
      }
    }
  },
  methods: {
    register() {
      if (this.input.email !== "" && this.input.username !== "" && this.input.password !== "" && this.input.password_v2 !== "") {
        axios.post(config.registerURL, {
          "name": this.input.username,
          "email": this.input.email,
          "password": this.input.password,
          "password_confirmation": this.input.password_v2
        }).then(() => this.$router.push({path: '/login'}))
        .catch(err => console.log(err.message));
      }
    }
  }
}
</script>

<style scoped>

</style>