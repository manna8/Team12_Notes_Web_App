<template>
  <div id="profile">
    <div class="container my-3 border bg-light mx-auto  border-warning rounded">
      <h2 class="text-center text-black"> Hello {{ userDetails.name }}!</h2>
      <h5 class="text-center text-black">{{ userDetails.email }}</h5>
      <div class="text-center p-1 m-1" >
        <button class="btn btn-sm btn-danger" @click="deleteUser">Delete account</button>
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

      if (this.passwordsMatch && this.input.newPassword === "") {
        axios.post(config.updateUserURL + this.userDetails._id.$oid, {
          "name": this.input.newUsername,
          "email": this.input.newEmail,
        }, {withCredentials: true})
            .then(() => {
              this.$router.go(0);

              this.$swal({
                position: 'top-end',
                icon: 'success',
                title: 'Details changed successfully',
                showConfirmButton: false,
                timer: 1000
              });
            })
            .catch((error) => {
              this.$swal({
                icon: 'error',
                title: 'Ooops...',
                text: error.response.data.errors[0],
                confirmButtonColor: '#ffc90b',
              });
            });
      } else if (this.passwordsMatch){
        axios.post(config.updateUserURL + this.userDetails._id.$oid, {
          "name": this.input.newUsername,
          "email": this.input.newEmail,
          "password": this.input.newPassword,
          "password_confirmation": this.input.newPasswordRepeat
        }, {withCredentials: true})
            .then(() => {
              this.$router.go(0);

              this.$swal({
                position: 'top-end',
                icon: 'success',
                title: 'Details changed successfully',
                showConfirmButton: false,
                timer: 1000
              });
            })
            .catch((error) => {
              this.$swal({
                icon: 'error',
                title: 'Ooops...',
                text: error.response.data.errors[0],
                confirmButtonColor: '#ffc90b',
              });
            });
      }

    },

    checkPasswordValidity() {
      this.passwordsMatch = this.input.newPassword === this.input.newPasswordRepeat;
    },

    deleteUser() {
      const id = this.userDetails._id.$oid;

      this.$swal({
        title: 'Delete your account?',
        text: "Are you sure? You won't be able to revert this!",
        type: 'warning',
        backdrop: `
          rgba(255, 184, 0, 0.3)
          url("../assets/sad.gif")
          left top
          no-repeat
        `,
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'No, cancel!',
        buttonsStyling: true
      }).then((isConfirm) => {
        if(isConfirm.value) {
          axios.delete(config.updateUserURL + id, {withCredentials: true})
              .then(() => this.$router.push({path: '/'}))
              .then(() => this.$store.commit('logout'))
              .catch(err => console.log(err.message));
        }
      });
    },

  },

  mounted() {
    this.getUserInfo();
  }
}
</script>

<style scoped>

</style>