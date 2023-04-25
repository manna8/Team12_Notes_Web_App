<template>
<div>
  <div class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: auto">
    <h1 class="text-center text-warning">{{ collection.title }}</h1>
  </div>

  <div class="overflow-auto">
    <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0" style="width: auto; height: auto">
      <ul v-for="note in notes" v-bind:key="note.title">
        <div class="col">
          <div class="card" style="max-width: 18rem; background-color: #404040">
            <div class="card-body">
              <li class="list-group-item">
                <h4 class="text-warning">{{ note.title }}</h4>
                <p class="text-white">{{ note.description }}</p>
                <button class="btn btn-outline-warning">Remove from collection</button>


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
  name: "EditCollection",

  data() {
    return {
      id: '',
      collection: [],
      notes: []
    }
  },
  methods: {
    async getCollection() {
      const res = await axios.get(config.getCollectionURL + this.id, {withCredentials: true});
      this.collection = res.data.notes_collection;
      this.notes = res.data.notes;

      console.log(this.collection);
      console.log(this.notes);
    },


  },
  created() {
    this.id = this.$route.params.id;
    this.getCollection();
    // this.getNotes();
  }
}
</script>

<style scoped>

</style>