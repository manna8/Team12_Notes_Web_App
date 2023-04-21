<template>
  <div id="profile">
    <div class="container my-3 border bg-light mx-auto  border-warning rounded">
      <h2 class="text-center text-warning"> Hello {{ userDetails.name }}!</h2>
      <h5 class="text-center text-black">{{ userDetails.email }}</h5>
      <div class="text-center p-1 m-1" >
        <button class="btn btn-sm btn-danger">Delete account</button>
      </div>
    </div>

      <form class="container p-3 border bg-light mx-auto border-warning rounded" style="width: auto; height: auto">
        <h3 class="text-center text-warning">Update your profile details:</h3>

        <br>

        <h5 class="text-center">Change your email:</h5>
        <div class="form-floating mb-3 d-flex flex-column align-items-start">
          <input type="email" class="form-control" id="floatingInput" placeholder="name@example.com" v-model="input.newEmail">
          <label for="floatingInput">Email address</label>
        </div>

        <h5 class="text-center">Change your username:</h5>
        <div class="form-floating mb-3 d-flex flex-column align-items-start">
          <input type="text" class="form-control" id="floatingInput" placeholder="Enter username" v-model="input.newUsername">
          <label for="floatingInput">Enter username</label>
        </div>

          <h5 class="text-center">Change your password:</h5>
          <div class="row g-2">
            <div class="col-md">
              <div class="form-floating mb-3 d-flex flex-column align-items-start">
                <input type="text"  class="form-control" id="floatingInput" placeholder="Enter password" aria-label="Enter password" v-model="input.newPassword">
                <label for="floatingInput">Enter new password</label>
                <p class="text-warning text-opacity-75"  v-if="!passwordsMatch">Oh no, passwords don't match!</p>
              </div>
            </div>

            <div class="col-md">
              <div class="form-floating mb-3 d-flex flex-column align-items-start">
                <input type="text"  class="form-control" id="floatingInput" placeholder="Enter password" aria-label="Enter password" v-model="input.newPasswordRepeat">
                <label for="floatingInput">Repeat password</label>
              </div>
            </div>
        </div>


        <div class="text-center">
          <button type="submit" class="btn btn-outline-dark" @click.prevent="changeUserDetails">Apply Changes</button>
        </div>
      </form>

  </div>
</template>

<script>

import config from "../../config/config";
import axios from "axios";

export default {
  name: "Profile",

  data() {
    return {
      userDetails: [],
      passwordsMatch: true,
      passwordValid: true,

      input: {
        newEmail: "",
        newUsername: "",
        newPassword: "",
        newPasswordRepeat: ""
      }
    }
  },

  methods: {
    async getUserInfo() {
      const response = await axios.get(config.getUserInfoURL, {withCredentials: true});
      this.userDetails = response.data.user;
      console.log(this.userDetails);

      this.setLocalInfo();
      console.log(this.input);
    },

    setLocalInfo() {
      this.input.newEmail = this.userDetails.email;
      this.input.newUsername = this.userDetails.name;
    },

    changeUserDetails() {
      this.checkPasswordValidity();

    },

    checkPasswordValidity() {
      if (this.input.newPassword !== this.input.newPasswordRepeat) {
        this.passwordsMatch = false;
      } else {
        this.passwordsMatch = true;
      }
    },

  },

  mounted() {
    this.getUserInfo();
  }
}
</script>

<style scoped>

</style>