<template id="register">
  <div id="register">

    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: auto" @click.prevent>
      <h2 class="text-center text-warning">Register!</h2>

      <div class="form-floating mb-3 d-flex flex-column align-items-start">
        <input type="text" class="form-control" id="floatingInput" placeholder="Enter username" v-model="input.username">
        <label for="floatingInput">Username</label>
        <p class="text-warning text-opacity-75" v-if="!usernameValid">Please provide an username!</p>
      </div>

      <div class="form-floating mb-3 d-flex flex-column align-items-start">
        <input type="email" class="form-control" id="floatingInput" placeholder="Enter email" v-model="input.email">
        <label for="floatingInput">Email address</label>
        <p class="text-warning text-opacity-75" v-if="!emailValid">Please provide an email!</p>
      </div>

      <div class="form-floating mb-3 d-flex flex-column align-items-start">
        <input type="password" class="form-control" id="floatingInput" placeholder="Enter password" v-model="input.password">
        <label for="floatingInput">Password</label>
        <p class="text-warning text-opacity-75" v-if="!passwordValid">Please provide a password!</p>
      </div>

      <div class="form-floating mb-3 d-flex flex-column align-items-start">
        <input type="password" class="form-control" id="floatingInput" placeholder="Repeat password" v-model="input.password_v2">
        <label for="floatingInput">Repeat password</label>
        <p class="text-warning text-opacity-75"  v-if="!passwordsMatch">Oh no, passwords don't match!</p>
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
      },
      emailValid: true,
      usernameValid: true,
      passwordValid: true,
      passwordsMatch: true
    }
  },
  methods: {
    register() {
      this.checkValidity();

      if (this.emailValid && this.usernameValid && this.passwordValid && this.passwordsMatch) {
        axios.post(config.registerURL, {
          "name": this.input.username,
          "email": this.input.email,
          "password": this.input.password,
          "password_confirmation": this.input.password_v2
        }).then(() => this.$router.push({path: '/login'}))
        .catch(err => console.log(err.message));
      }
    },
    checkValidity() {
      if (this.input.password === "") {
        this.passwordValid = false;
      } else {
        this.passwordValid = true;
      }

      if (this.input.username === "") {
        this.usernameValid = false;
      } else {
        this.usernameValid = true;
      }

      if (this.input.email === "") {
        this.emailValid = false;
      } else {
        this.emailValid = true;
      }

      if (this.input.password !== this.input.password_v2) {
        this.passwordsMatch = false;
      } else {
        this.passwordsMatch = true;
      }
    }
  }
}
</script>

<style scoped>

</style>