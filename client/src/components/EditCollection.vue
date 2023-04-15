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
                <div v-if="inCollection(note._id)">
                  <button class="btn btn-outline-warning">Remove from collection</button>
                </div>
                <div v-else>
                  <button class="btn btn-outline-warning">Add to collection</button>
                </div>

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
      this.collection = res.data;

      console.log(this.collection);
    },
    async getNotes() {
      const res = await axios.get(config.getNotesURL, {withCredentials: true});
      this.notes = res.data;
    },
    inCollection(id) {
      console.log(id);
    }

  },
  created() {
    this.id = this.$route.params.id;
    this.getCollection();
    this.getNotes();
  }
}
</script>

<style scoped>

</style>