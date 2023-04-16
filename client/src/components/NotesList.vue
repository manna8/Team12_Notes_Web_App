<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0" style="width: auto; height: auto">
        <ul v-for="note in notes" v-bind:key="note.title">
          <div class="col">
          <div class="card" style="max-width: 18rem">
            <img src={{getImageURL(note)}} class="card-img-top" alt="image :/">
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
        return "../assets/background2.png";
      } else {
        return note.photo_url;
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