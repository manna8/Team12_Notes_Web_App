<template>
  <div id="profile">
    <div class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded">
      <h2 class="text-center text-warning"> Hello {{ userDetails.name }}!</h2>
      <h5 class="text-center text-black">{{ userDetails.email }}</h5>
    </div>

      <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: auto; height: auto">
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
          <button type="submit" class="btn btn-outline-dark" @click.prevent="getUserInfo">Apply Changes</button>
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
    }
  },

  mounted() {
    this.getUserInfo();
  }
}
</script>

<style scoped>

</style>