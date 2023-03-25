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
      <br>
      <div class="row ms-auto overflow-auto" style="height: 500px">
        <div class="col h-100 d-inline-block">
          <CollectionsList />
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import CollectionsList from "@/components/CollectionsList.vue";

import axios from "axios";
import config from "../../config/config";

export default {
  name: "Collections",
  components: {CollectionsList},

  data() {
    return {
      input: {
        title: ""
      }
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
    }
  }
}
</script>

<style scoped>

</style>