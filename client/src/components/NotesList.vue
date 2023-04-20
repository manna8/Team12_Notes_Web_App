<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0" style="width: auto; height: auto">
        <ul v-for="note in notes" v-bind:key="note.title">
          <div class="col">
          <div class="card" style="max-width: 18rem">
            <img src="../assets/background4.png" class="card-img-top" alt="image :/">
            <div class="card-body">
              <h5 class="note-title">{{ note.title }}</h5>
              <p class="note-text">{{ note.description }}</p>
              <router-link :to="'/notes/' + note._id.$oid" class="btn btn-outline-warning">Details</router-link>
              <button class="btn btn-outline-dark" @click="deleteNote(note._id)">Delete note</button>
            </div>
          </div>
          </div>
        </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded" v-else>
        <h3>You don't have any notes yet!</h3>
      </div>
    </div>
  </div>

</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "NotesList",
  props: {
    id: String,
    title: String,
    description: Number
  },

  data() {
    return {
      notes: []
    };
  },

  methods: {
    deleteNote(id) {
      axios.delete(config.deleteNotesURL + id.$oid, {withCredentials: true})
      .then(() => this.getNotes())
      .catch(err => console.log(err.message));
    },
    async getNotes() {
      const res = await axios.get(config.getNotesURL, {withCredentials: true});
      this.notes = res.data;
      console.log(this.notes);
    },
    getImageURL(note) {
      console.log(note);
      if (note.photo_url === "" || note.photo_url === null) {
        return note.photo_url;
      } else {
        return "http://localhost:8080/assets/background4.png";
      }
    }

  },
  mounted() {
    this.getNotes();
  }
}
</script>

<style scoped>

</style>