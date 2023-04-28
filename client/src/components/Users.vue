<template>
<div class="container m-3">
  <div class="overflow-auto">
    <div class="row row-cols-1 row-cols-md-5 " v-if="users.length !== 0" style="width: auto; height: 600px">
        <ul v-for="user in users" v-bind:key="user._id.$oid">
          <div class="col text-center m-3">
            <div class="card" style="max-width: 15rem">
              <div class="card-body">
                <form>
                  <label for="username">Username: </label>
                  <input type="text" id="username" v-model="user.name">

                  <label for="email">Email: </label>
                  <input type="email" id="email" v-model="user.email">

                  <label for="id">User Id: </label>
                  <input type="text" id="id" v-model="user._id.$oid" disabled>

                  <button class="btn btn-outline-warning m-2" @click.prevent="editUser(user._id.$oid, user.name, user.email)">Save</button>
                  <button class="btn btn-outline-dark" @click="deleteUser(user._id.$oid)">Delete user</button>
                </form>
              </div>
            </div>
          </div>
        </ul>
    </div>
    <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded" v-else>
      <div class="text-center">
        <h3>There are no users' accounts in database!</h3>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "Users",

  data() {
    return {
      users: [],
      friendships: [],
      message: '',
    }
  },

  methods: {
    async getAllUsers() {
      const res = await axios.get(config.getAllUsers, {withCredentials: true})
          .catch(err => console.log(err));
      this.users = res.data;
    },
    async getFriendships() {
      const res = await axios.get(config.answerFriendRequestURL, {withCredentials: true});
      this.friendships = res.data;
    },
    editUser(id, name, email) {
      if (name === "" || email === "") {
        this.$swal({
          icon: 'error',
          title: 'Ooops...',
          text: 'User\'s name and email must not be empty!',
          confirmButtonColor: '#ffc90b',
        });
      }

      axios.post(config.updateUserURL + id, {
        "name": name,
        "email": email,
      }, {withCredentials: true})
          .then(() => this.$router.go(0));
    },
    deleteUser(id) {
      axios.delete(config.updateUserURL + id, {withCredentials: true})
          .then(() => this.$router.push(0))
          .catch(err => console.log(err.message));
    },
  },

  mounted() {
    this.getAllUsers();
    this.getFriendships();
  }
}
</script>

<style scoped>

</style>