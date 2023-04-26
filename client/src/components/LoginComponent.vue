<template id="login">
 <div id="login">

  <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" v-bind:style="[isMobile() ? styleMobile : styleWeb]" @click.prevent>
    <h2 class="text-center text-warning">Login!</h2>

    <br>

    <div class="form-floating mb-3 d-flex flex-column align-items-start">
      <input type="email" class="form-control" id="floatingInput" placeholder="name@example.com" v-model="input.username">
      <label for="floatingInput">Email address</label>
      <p class="text-warning text-opacity-75" v-if="!usernameValid">Please provide an email!</p>
    </div>

    <div class="form-floating mb-3 d-flex flex-column align-items-start">
      <input type="password" class="form-control" id="floatingInput" placeholder="Enter password" v-model="input.password">
      <label for="floatingInput">Password</label>
      <p class="text-warning text-opacity-75" v-if="!passwordValid">Please provide a password!</p>
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
      },
      styleWeb: {
        width: '400px',
        height: '350px'
      },
      styleMobile: {
        width: '300px',
        height: 'auto'
      },
      usernameValid: true,
      passwordValid: true
    }
  },
  methods: {
    login() {
      this.passwordValid = this.input.password !== "";
      this.usernameValid = this.input.username !== "";

      if (this.usernameValid && this.passwordValid) {
        axios.post(config.loginURL, {
          "email": this.input.username,
          "password": this.input.password
        }, {withCredentials: true})
            .then(() => {
              this.$router.push({path: '/notes'})

              const myCookie = Cookies.get('jwt');
              console.log(myCookie);

              this.$store.commit('login');
              console.log(this.$store.state.loggedIn);

              this.$swal({
                position: 'top-end',
                icon: 'success',
                title: 'Logged in successfully',
                showConfirmButton: false,
                timer: 1000
              });

            })
            .catch((error) => {
              this.$swal({
                icon: 'error',
                title: 'Ooops...',
                text: error.response.data.message,
                confirmButtonColor: '#ffc90b',
              });

            });

      } else if (this.input.password !== ""){
        this.passwordValid = false;
      }
    },
    isMobile() {
      return screen.width < 500;
    }

  }
}
</script>

<style scoped>

</style>