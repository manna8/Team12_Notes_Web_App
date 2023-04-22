<template>
  <div id="friends">
      <form class="container p-3 my-3 mx-auto mb-3 mt-5" style="width: 450px; height: auto">
        <div class="input-group mb-3">
          <input type="text" class="form-control" placeholder="Friend's email" aria-label="Friend's email" v-model="input.email">
          <button class="btn btn-warning" type="button" @click="addFriend">Add Friend</button>
        </div>
        <p class="text-warning text-opacity-75" v-if="!emailValid">Please provide an username!</p>
      </form>
      <div class="accordion" id="accordionExample">
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
              Yours friends list
            </button>
          </h2>
          <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#accordionExample">
            <div class="accordion-body" v-if="friendsList.length !== 0">
              <ul class="list-group" v-for="friend in friendsList" v-bind:key="friend._id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                  <div class="container justify-content-end">
                    <button class="btn btn-danger btn-sm" type="button" @click="removeFriend()">Remove friend</button>
                  </div>
                </li>
              </ul>
            </div>
            <div class="accordion-body" v-else>
              <h5>You don't have any friends yet sucker!</h5>
            </div>
          </div>
        </div>
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
              Pending friends requests
            </button>
          </h2>
          <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
            <div class="accordion-body">
              <ul class="list-group" v-for="friend in receivedFriendRequests" v-bind:key="friend._id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                  <div class="container">
                    <button class="btn btn-success btn-sm" type="button" @click="acceptFriend(friend._id)">Accept</button>
                    <button class="btn btn-danger btn-sm" type="button" @click="declineFriend(friend._id)">Decline</button>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
              Sent friend requests
            </button>
          </h2>
          <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
            <div class="accordion-body">
              <ul class="list-group" v-for="friend in sentFriendRequests" v-bind:key="friend._id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "Friends",

  data() {
    return {
      input: {
        email: "",
      },
      emailValid: true,
      friendsList: [],
      sentFriendRequests: [],
      receivedFriendRequests: [],
    }
  },
  methods: {
    async getFriends() {
      // const res = await axios.get(config.getFriendsURL, {withCredentials: true})
      //     .then(() => {
      //       console.log(res.data);
      //       this.friendsList = res.data;
      //     })
      //     .catch(err => console.log(err));
    },
    async getReceivedFriends() {
      const res = await axios.get(config.getReceivedFriendsURL, {withCredentials: true})
          .then(() => console.log('jeej'))
          .catch(err => console.log(err));

      console.log(res.data);
    },
    addFriend() {
      if (this.input.email === "") {
        this.emailValid = false;
      } else {
        this.emailValid = true;

        axios.post(config.addFriendURL, {
          "email": this.input.email,
        }, {withCredentials: true})
            .then(() => this.$router.go(0))
            .catch(err => console.log(err.message));
      }
    },
    removeFriend() {
      axios.delete(config.addFriendURL, {
        "email": this.input.email,
      }, {withCredentials: true})
          .then(() => this.$router.go(0))
          .catch(err => console.log(err.message));
    },
    acceptFriend(id) {
      //axios.post()
      console.log("Accepted invitation from friend with id:", id)
      this.$router.go(0);
    },
    declineFriend(id) {
      //axios.post()
      console.log("Declined invitation from friend with id:", id)
      this.$router.go(0);
    }
  },

  mounted() {
    this.getFriends();
    this.getReceivedFriends();
  }

}
</script>

<style scoped>

</style>