<template>
  <div id="collections">
    <div class="container">

      <div class="row ms-auto">
        <div class="col">
          <div  class="d-grid">
            <form class="container p-3 my-3 mx-auto mb-3 mt-5" style="width: 450px; height: auto">
              <div class="input-group mb-3">
                <input type="text" class="form-control" placeholder="Collection title" aria-label="Collection title" v-model="input.title">
                <button class="btn btn-warning" type="button" @click="createCollection">Create Collection</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <div class="row ms-auto">
        <div class="col">
          <div  class="d-grid">
            <div class="btn-group" role="group" aria-label="Basic outlined example">
              <button type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showUserCollections }" @click="toggleUserCollections">Your collection</button>
              <button type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showSharedWithUserCollections  }" @click="toggleSharedCollections">Collections shared with you</button>
              <button type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showSharingCollections  }" @click="toggleSharingCollections">Collections you are sharing</button>
            </div>
          </div>
        </div>
      </div>

      <br>

      <div class="row ms-auto overflow-auto" style="height: 500px">
        <div class="col h-100 d-inline-block">
          <div v-if="showUserCollections">
            <CollectionsList />
          </div>
          <div v-if="showSharingCollection">
            <SharingCollectionsList></SharingCollectionsList>
          </div>
          <div v-if="showSharedWithUserCollections">
            <SharedCollectionsList></SharedCollectionsList>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import CollectionsList from "@/components/CollectionsList.vue";
import SharedCollectionsList from "@/components/SharedCollectionsList.vue";
import SharingCollectionsList from "@/components/SharingCollectionsList.vue";

import axios from "axios";
import config from "../../config/config";

export default {
  name: "Collections",
  components: {CollectionsList, SharedCollectionsList, SharingCollectionsList},

  data() {
    return {
      input: {
        title: ""
      },
      showUserCollections: true,
      showSharingCollection: false,
      showSharedWithUserCollections: false,
    }
  },

  methods: {
    createCollection() {
      if (this.input.title !== "") {
        axios.post(config.addCollectionsURL, {
          "title": this.input.title,
          "description" : this.input.title
        }, {withCredentials: true})
            .then(res => console.log(res))
            .catch(err => console.log(err))

        this.$router.go(0);
      }
    },
    toggleUserCollections() {
      this.showUserCollections = !this.showUserCollections;

      if (this.showSharedWithUserCollections) {
        this.showSharedWithUserCollections = false;
      }

      if (this.showSharingCollection) {
        this.showSharingCollection = false;
      }
    },

    toggleSharedCollections() {
      this.showSharedWithUserCollections = !this.showSharedWithUserCollections;

      if (this.showUserCollections) {
        this.showUserCollections = false;
      }

      if (this.showSharingCollection) {
        this.showSharingCollection = false;
      }
    },

    toggleSharingCollections() {
      this.showSharingCollection = !this.showSharingCollection;

      if (this.showUserCollections) {
        this.showUserCollections = false;
      }

      if (this.showSharedWithUserCollections) {
        this.showSharedWithUserCollections = false;
      }
    }
  }
}
</script>

<style scoped>

</style>