<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0" style="width: auto; height: auto">
        <ul v-for="note in notes" v-bind:key="note.title">
          <div class="col">
            <div class="card" style="max-width: 18rem">
              <img :src="getImageURL(note)" class="card-img-top" alt="image :/">
              <div class="card-body">
                <h5 class="note-title">{{ note.title }}</h5>
                <p class="note-text">{{ note.description }}</p>
                <router-link :to="'/notes/' + note._id.$oid" class="btn btn-outline-warning">Details</router-link>
                <button class="btn btn-outline-dark" @click="deleteNote(note._id)">Delete note</button>
                <button class="btn btn-outline-dark" data-bs-toggle="modal" data-bs-target="#staticBackdrop">Share note</button>
              </div>
            </div>
          </div>
        </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded" v-else>
        <div class="text-center">
          <h3>You don't have any notes yet!</h3>
        </div>
      </div>
    </div>

    <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="staticBackdropLabel">Share with your friends</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="container" v-if="friendsList.length !== 0">
              <ul class="list-group" v-for="friend in friendsList" v-bind:key="friend.name">
                <li class="list-group-item">


                  <div class="input-group">

                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                      <label class="form-check-label" for="flexCheckDefault">
                        <h5>{{ friend.name }}</h5>
                      </label>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <div v-else>
              <h5>You don't have any friends :(</h5>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary">Share</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "SharingNotesList",

  data() {
    return {
      notes: [],
      friendsList: []
    };
  },

  methods: {
    async getNotes() {
      const res = await axios.get(config.getSharingNotesURL, {withCredentials: true});
      this.notes = res.data;
      console.log(this.notes);
    },
  },

  mounted() {
    this.getNotes();
  }
}
</script>

<style scoped>

</style>