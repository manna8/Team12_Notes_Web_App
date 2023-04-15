<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="collections.length !== 0" style="width: auto; height: auto">
        <ul v-for="collection in collections" v-bind:key="collection.title">
          <div class="col">
            <div class="card" style="max-width: 18rem; background-color: #404040">
              <div class="card-body">
                <li class="list-group-item">
                  <h4 class="text-white">{{ collection.title }}</h4>
                  <router-link :to="'/collections/' + collection._id.$oid" class="btn btn-warning">Details</router-link>
                  <button class="btn btn-outline-warning" @click="deleteCollection(collection._id)">Delete Collection</button>
                </li>
              </div>
            </div>

          </div>
        </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded" v-else>
        <h3>You don't have any collections yet!</h3>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "CollectionsList",

  data() {
    return {
      collections: []
    }
  },
  methods: {
    deleteCollection(id) {
      axios.delete(config.deleteCollectionURL + id.$oid, {withCredentials: true})
          .then(() => this.getCollections())
          .catch(err => console.log(err.message));
    },
    async getCollections() {
      const res = await axios.get(config.getCollectionsURL, {withCredentials: true});
      this.collections = res.data;
      console.log(this.collections);
    }
  },
  mounted() {
    this.getCollections();
  }
}
</script>

<style scoped>

</style>