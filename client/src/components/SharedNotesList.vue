<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0" style="width: auto; height: auto">
        <ul v-for="note in notes" v-bind:key="note.title">
          <div class="col">
            <div class="card" style="width: 15rem">
              <img :src="getImageURL(note)" class="card-img-top" alt="image :/">
              <div class="card-body">
                <h5 class="note-title">{{ note.title }}</h5>
                <p class="note-text">{{ note.description }}</p>
              </div>
            </div>
          </div>
        </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded" v-else>
        <div class="text-center">
          <h3>No one shared the notes with you yet!</h3>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "SharedNotesList",
  data() {
    return {
      notes: []
    };
  },

  methods: {
    async getNotes() {
      const res = await axios.get(config.getSharedNotesURL, {withCredentials: true});
      this.notes = res.data;
      console.log(this.notes);
    },
    getImageURL(note) {
      console.log(note);
      // if (note.photo_url === "" || note.photo_url === null) {
      //   return note.photo_url;
      // } else {
      //   return "http://localhost:8080/assets/background4.png";
      // }

      return require('../assets/background2.png');
    },
  },

  mounted() {
    this.getNotes();
    // console.log(this.notes);
  }
}
</script>

<style scoped>

</style>