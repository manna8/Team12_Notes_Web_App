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
            <div class="accordion-body">
              <ul class="list-group" v-for="friend in friendsList" v-bind:key="friend._id">
                <li class="list-group-item">
                  <h5>{{ friend.name }}</h5>
                  <div class="container justify-content-end">
                    <button class="btn btn-danger btn-sm" type="button" @click="removeFriend(friend._id)">Remove friend</button>
                  </div>
                </li>

              </ul>
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
              <ul class="list-group" v-for="friend in pendingFriendRequests" v-bind:key="friend._id">
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
export default {
  name: "Friends",

  data() {
    return {
      input: {
        email: "",
      },
      emailValid: true,
      friendsList: [{_id: 1, name: 'Thomas'}, {_id: 2, name: 'Lidia'}],
      sentFriendRequests: [{_id: 3, name: 'SuperChica29'}],
      pendingFriendRequests: [{_id: 4, name: 'Mom'}],
    }
  },
  methods: {
    addFriend() {
      if (this.input.email === "") {
        this.emailValid = false;
      } else {
        this.emailValid = true;

        //axios.post()
        this.$router.go(0);
      }
    },
    removeFriend(id) {
      //axios.post()
      console.log("Removed friend with id:", id)
      this.$router.go(0);
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
  }

}
</script>

<style scoped>

</style>