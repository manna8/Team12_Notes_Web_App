<template>
  <div id="collections">
    <div class="container">

      <div class="row ms-auto" v-if="!isAdmin">
        <div class="col">
          <div  class="d-grid">
            <form class="container p-3 my-3 mx-auto m-2 " v-bind:style="[isMobile() ? styleMobile : styleWeb]">
              <div class="input-group mb-3">
                <input type="text" class="form-control" placeholder="Collection title" aria-label="Collection title" v-model="input.title">
                <button class="btn btn-warning" type="button" @click="createCollection">Create Collection</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <div class="row ms-auto m-2">
        <div class="col">
          <div  class="d-grid">
            <div class="btn-group" role="group" aria-label="Basic outlined example">
              <button type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showUserCollections }" @click="toggleUserCollections">Your collections</button>
              <button v-if="!isAdmin" type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showSharedWithUserCollections  }" @click="toggleSharedCollections">Collections shared with you</button>
              <button v-if="!isAdmin" type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showSharingCollections  }" @click="toggleSharingCollections">Collections you are sharing</button>
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
          <div v-if="showSharingCollections">
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
import CollectionsList from "@/components/Collections/CollectionsList.vue";
import SharedCollectionsList from "@/components/Collections/SharedCollectionsList.vue";
import SharingCollectionsList from "@/components/Collections/SharingCollectionsList.vue";

import axios from "axios";
import config from "../../../config/config";

export default {
  name: "Collections",
  components: {CollectionsList, SharedCollectionsList, SharingCollectionsList},

  data() {
    return {
      input: {
        title: ""
      },
      styleWeb: {
        width: '400px',
        height: 'auto'
      },
      styleMobile: {
        width: '300px',
        height: 'auto'
      },
      showUserCollections: true,
      showSharingCollections: false,
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

      if (this.showSharingCollections) {
        this.showSharingCollections = false;
      }
    },
    toggleSharedCollections() {
      this.showSharedWithUserCollections = !this.showSharedWithUserCollections;

      if (this.showUserCollections) {
        this.showUserCollections = false;
      }

      if (this.showSharingCollections) {
        this.showSharingCollections = false;
      }
    },
    toggleSharingCollections() {
      this.showSharingCollections = !this.showSharingCollections;

      if (this.showUserCollections) {
        this.showUserCollections = false;
      }

      if (this.showSharedWithUserCollections) {
        this.showSharedWithUserCollections = false;
      }
    },
    isMobile() {
      return screen.width < 500;
    }
  },

  computed: {
    isAdmin() {
      return this.$store.state.admin;
    }
  }
}
</script>

<style scoped>

</style>