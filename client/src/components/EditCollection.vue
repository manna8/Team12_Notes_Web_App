<template>
<div>
  <div class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded"  v-bind:style="[isMobile() ? styleMobile : styleWeb]">
    <h1 class="text-center text-warning">{{ collection.title }}</h1>
  </div>

  <div class="overflow-auto">
    <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0"  v-bind:style="[isMobile() ? styleMobile : styleWeb]">
      <ul v-for="note in notes" v-bind:key="note.title">
        <div class="col">
          <div class="card" style="max-width: 18rem">
            <img :src="getImageURL(note)" class="card-img-top" alt="image :/">
            <div class="card-body">
              <h5 class="note-title">{{ note.title }}</h5>
              <p class="note-text">{{ note.description }}</p>
              <router-link :to="'/notes/' + note._id.$oid" class="btn btn-outline-warning">Details</router-link>
              <button class="btn btn-outline-dark" @click="deleteNote(note._id)">Delete note</button>
              <button class="btn btn-warning" @click="removeNoteFromCollection(note._id)">Remove from collection</button>
            </div>
          </div>

        </div>
      </ul>
    </div>
    <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded text-center" v-else>
      <h3>You haven't added any notes yet!</h3>
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
      notes: [],

      styleWeb: {
        width: '600px',
        height: 'auto'
      },
      styleMobile: {
        width: '300px',
        height: 'auto'
      },
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
    removeNoteFromCollection(id) {
      axios.post(config.updateNoteURL + id.$oid, {
        "notes_collection_id": "",
      }, {withCredentials: true}).then(res => console.log(res))
          .then(() => this.$router.go(0))
          .catch(err => console.log(err.message));
    },
    getImageURL(note) {
      if (note.photo !== null) {
        let img = new Image();
        img.src = 'data:image/png;base64,' + note.photo;
        return img.src;
      } else {
        return require('../assets/background2.png');
      }
    },
    deleteNote(id) {
      axios.delete(config.deleteNotesURL + id.$oid, {withCredentials: true})
          .then(() => this.getNotes())
          .catch(err => console.log(err.message));
    },
    isMobile() {
      return screen.width < 500;
    }
  },

  created() {
    this.id = this.$route.params.id;
    this.getCollection();
  }
}
</script>

<style scoped>

</style>