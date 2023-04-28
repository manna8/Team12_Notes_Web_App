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
                </li>
              </div>
            </div>

          </div>
        </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded" v-else>
        <div class="text-center">
          <h3>No one shared any collection with you yet!</h3>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from "axios";
import config from "../../../config/config";

export default {
  name: "SharedCollectionsList",

  data() {
    return {
      collections: []
    };
  },

  methods: {
    async getCollections() {
      const res = await axios.get(config.getSharedCollectionsURL, {withCredentials: true});
      this.collections = res.data;
      console.log(this.collections);
    },
  },

  mounted() {
    this.getCollections();
  }
}
</script>

<style scoped>

</style>