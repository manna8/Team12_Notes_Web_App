<template>
  <div class="container m-3">
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-5 " v-if="friendships.length !== 0" style="width: auto; height: 600px">

    <ul v-for="friendship in friendships" v-bind:key="friendship._id.$oid">
      <div class="col text-center m-3">
      <div class="card" style="width: 20rem">
        <div class="card-body">
          <form>
            <label for="id">Request id: </label>
            <input type="text" id="id" v-model="friendship._id.$oid" disabled>

            <label for="from">From: </label>
            <input type="text" id="from" v-model="friendship.sender"  disabled>

            <label for="to">To: </label>
            <input type="text" id="to" v-model="friendship.receiver" disabled>

            <label for="status">Status: </label>
            <input type="text" id="status" v-model="friendship.status" disabled>
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
    }
  },
  mounted() {
    this.getFriendships();
  }
}
</script>

<style scoped>

</style>