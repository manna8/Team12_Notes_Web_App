<template>
  <div id="friends">
      <form class="container p-3 my-3 mx-auto mb-3 mt-5"  v-bind:style="[isMobile() ? styleMobile : styleWeb]">
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
              <ul class="list-group" v-for="friend in friendsList" v-bind:key="friend.friendship_id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                  <div class="container justify-content-end">
                    <button class="btn btn-danger btn-sm" type="button" @click="removeFriend(friend.friendship_id)">Remove friend</button>
                  </div>
                </li>
              </ul>
            </div>
            <div class="accordion-body" v-else>
              <h5>You don't have any friends yet :(</h5>
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
            <div class="accordion-body" v-if="receivedFriendRequests.length !== 0">
              <ul class="list-group" v-for="friend in receivedFriendRequests" v-bind:key="friend.friendship_id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                  <div class="container">
                    <button class="btn btn-success btn-sm" type="button" @click="acceptFriend(friend.friendship_id)">Accept</button>
                    <button class="btn btn-danger btn-sm" type="button" @click="declineFriend(friend.friendship_id)">Decline</button>
                    <button class="btn btn-danger btn-sm" type="button" @click="blockFriend(friend.friendship_id)">Block</button>
                  </div>
                </li>
              </ul>
            </div>
            <div class="accordion-body" v-else>
              <h5>No one sent you a request yet :(</h5>
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
            <div class="accordion-body" v-if="sentFriendRequests.length !== 0">
              <ul class="list-group" v-for="friend in sentFriendRequests" v-bind:key="friend._id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                </li>
              </ul>
            </div>
            <div class="accordion-body" v-else>
              <h5>You didn't send any request yet!</h5>
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
      styleWeb: {
        width: '400px',
        height: 'auto'
      },
      styleMobile: {
        width: '300px',
        height: 'auto'
      },

      emailValid: true,
      friendsList: [],
      sentFriendRequests: [],
      receivedFriendRequests: [],
    }
  },

  methods: {
    async getFriends() {
      const res = await axios.get(config.getFriendsURL, {withCredentials: true});
      this.friendsList = res.data;
    },
    async getReceivedFriends() {
      const res = await axios.get(config.getReceivedFriendsURL, {withCredentials: true});
      this.receivedFriendRequests = res.data;
    },
    async getPendingFriends() {
      const res = await axios.get(config.getPendingFriendsURL, {withCredentials: true});
      this.sentFriendRequests = res.data;
    },
    addFriend() {
      if (this.input.email === "") {
        this.emailValid = false;
      } else {
        this.emailValid = true;

        axios.post(config.addFriendURL, {
          "email": this.input.email,
        }, {withCredentials: true})
            .then(() => {
              this.$router.go(0);

              this.$swal({
                position: 'top-end',
                icon: 'success',
                title: 'Request sent successfully!',
                showConfirmButton: false,
                timer: 1000
              });
            })
            .catch(err => {
              console.log(err.response.data.message)
              if (err.response) {
                this.$swal({
                  icon: 'error',
                  title: err.response.data.message,
                  showConfirmButton: false,
                  timer: 1500
                });
              }
            });
      }
    },
    removeFriend(id) {
      this.$swal({
        title: 'Remove a friend?',
        text: "Are you sure? You won't be able to revert this!",
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, remove!',
        cancelButtonText: 'No, cancel!',
        buttonsStyling: true
      }).then((isConfirm) => {
        if(isConfirm.value) {
          axios.delete(config.removeFriendURL + id.$oid, {withCredentials: true})
              .then(() => this.$router.go(0))
              .catch(err => console.log(err.message));
        }
      });
    },
    acceptFriend(id) {
      axios.put(config.answerFriendRequestURL + id.$oid, {
        "status": "accepted",
      }, {withCredentials: true})
          .then(() => {
            this.$router.go(0);

            this.$swal({
              position: 'top-end',
              icon: 'success',
              title: 'Friends request accepted!',
              showConfirmButton: false,
              timer: 1000
            });
          })
          .catch(err => console.log(err.message));
    },
    declineFriend(id) {
      axios.delete(config.removeFriendURL + id.$oid, {withCredentials: true})
          .then(() => this.$router.go(0))
          .catch(err => console.log(err.message));
    },
    blockFriend(id) {
      axios.put(config.answerFriendRequestURL + id.$oid, {
        "status": "blocked",
      }, {withCredentials: true})
          .then(() => {
            this.$router.go(0);

            this.$swal({
              position: 'top-end',
              icon: 'success',
              title: 'Friends request declined!',
              showConfirmButton: false,
              timer: 1000
            });
          })
          .catch(err => console.log(err.message));
    },
    isMobile() {
      return screen.width < 500;
    }
  },

  mounted() {
    this.getFriends();
    this.getReceivedFriends();
    this.getPendingFriends();
  }
}
</script>

<style scoped>

</style>