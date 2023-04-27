<template>
  <div class="container m-3">
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-5 " v-if="friendships.length !== 0" style="width: auto; height: 600px">
        <ul v-for="friendship in friendships" v-bind:key="friendship._id.$oid">
          <div class="col text-center">
          <div class="card text-center" style="max-width: 25rem">
            <div class="card-body text-center">
              <form class="text-center">
                <label for="id">Request id: </label>
                <input type="text" id="id" v-model="friendship._id.$oid" disabled>

                <label for="from">From user: </label>
                <input type="text" id="from" v-model="friendship.sender"  disabled>

                <label for="to">To user: </label>
                <input type="text" id="to" v-model="friendship.receiver" disabled>

                <div class="text-center">
                  <div>Status: </div>

                  <select v-model="friendship.status">
                    <option value ="accepted">Accepted</option>
                    <option value ="pending">Pending</option>
                    <option value ="blocked">Blocked</option>
                  </select>
                </div>

                <button class="btn btn-outline-warning m-2" @click.prevent="editFriendship(friendship._id.$oid, friendship.status)">Save</button>
                <button class="btn btn-outline-dark" @click="removeFriendship(friendship._id.$oid)">Delete friendship</button>
              </form>
            </div>
          </div>
          </div>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "Friendships",

  data() {
    return {
      friendships: []
    }
  },
  methods: {
    async getFriendships() {
      const res = await axios.get(config.getAllFriendshipsURL, {withCredentials: true});
      this.friendships = res.data;

      console.log(this.friendships);
    },

    removeFriendship(id) {
      axios.delete(config.removeFriendURL + id, {withCredentials: true})
          .then(() => this.$router.go(0))
          .catch(err => console.log(err.message));

      this.$router.go(0);
    },

    editFriendship(id, friendshipStatus) {
      axios.put(config.answerFriendRequestURL + id, {
        "status": friendshipStatus,
      }, {withCredentials: true})
          .then(() => this.$router.go(0))
          .catch(err => console.log(err.message));
    }
  },
  mounted() {
    this.getFriendships();
  }
}
</script>

<style scoped>

</style>