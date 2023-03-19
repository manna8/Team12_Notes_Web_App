<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length === 0">
      <ul v-for="(note, index) in notes" v-bind:key="note.title">
        <div class="col">
        <div class="card" style="width: 18rem;">
          <img src="../assets/background2.png" class="card-img-top" alt="image :/">
          <div class="card-body">
            <h5 class="note-title">{{ note.title }}</h5>
            <p class="note-text">{{ note.description }}</p>
            <a href="#" class="btn btn-warning">Details</a>
            <button class="btn btn-outline-dark" @click="deleteNote(index)">Delete note</button>
          </div>
        </div>
        </div>
      </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded"  v-else>
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
    title: String,
    description: Number
  },

  data() {
    return {

      notes: [
        // {title: 'Shopping',
        //   description: 'My shopping list'},
        //
        // {title: 'Gifts',
        //   description: 'Gift ideas'
        // },
        // {title: 'Gifts',
        //   description: 'Gift ideas'
        // },
        // {title: 'Gifts',
        //   description: 'Gift ideas'
        // },
        // {title: 'Gifts',
        //   description: 'Gift ideas'
        // },
        // {title: 'Gifts',
        //   description: 'Gift ideas'
        // }
      ]
    };
  },
  methods: {
    deleteNote(idx) {
      this.notes.splice(idx, 1);
    },
    getNotes() {
      this.notes = axios.get(config.getNotesURL, {withCredentials: true});
    }
  },
  mounted() {
    this.getNotes();
  }
}
</script>

<style scoped>

</style>