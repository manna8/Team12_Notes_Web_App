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
              <button class="btn btn-outline-dark" data-bs-toggle="modal" data-bs-target="#staticBackdrop" @click="sharedNoteId = note._id">Share note</button>
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
            <div class="container" v-if="friendsListWithId.length !== 0">
              <ul class="list-group" v-for="friend in friendsListWithId" v-bind:key="friend.name">
                <li class="list-group-item">

                  <div class="input-group">

                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" :value="friend.id.$oid" :id="friend.name" v-model="friendsToShare">
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
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" @click="sharedNoteId=null; friendsToShare=[]">Close</button>
            <button type="button" class="btn btn-warning" @click="shareNote()">Share</button>
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
  name: "NotesList",

  props: {
    id: String,
    title: String,
    description: Number
  },

  data() {
    return {
      notes: [],
      friendsList: [],
      friendsListWithId: [],
      sharedNoteId: null,
      friendsToShare: []
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
      // if (note.photo_url === "" || note.photo_url === null) {
      //   return note.photo_url;
      // } else {
      //   return "http://localhost:8080/assets/background4.png";
      // }

      return require('../assets/background2.png');
    },
    async getFriends() {
      const res = await axios.get(config.getFriendsURL, {withCredentials: true});
      this.friendsList = res.data;
      console.log(this.friendsList);
    },
    async getFriendsWithId() {
      const res = await axios.get(config.getFriendsWithIdURL, {withCredentials: true});
      this.friendsListWithId = res.data;
      console.log(this.friendsList);
    },
    shareNote() {
      console.log(this.friendsToShare);

      axios.post(config.updateSharingNotesURL + this.sharedNoteId.$oid + '/sharing_update', this.friendsToShare, {withCredentials: true})
          .then(() => console.log('Hurraa!'))
          .catch(err => console.log(err));

      this.friendsToShare = [];
      this.sharedNoteId = null;
    }
  },

  mounted() {
    this.getNotes();
    this.getFriends();
    this.getFriendsWithId();
    console.log(this.friendsList);
  }
}
</script>

<style scoped>

</style>