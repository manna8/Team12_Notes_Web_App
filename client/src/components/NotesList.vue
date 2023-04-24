<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="notes.length !== 0" style="width: auto; height: auto">
        <ul v-for="note in notes" v-bind:key="note.title">
          <div class="col">
          <div class="card" style="max-width: 15rem">
            <img :src="getImageURL(note)" class="card-img-top" alt="image :/">
            <div class="card-body">
              <h5 class="note-title">{{ note.title }}</h5>
              <p class="note-text">{{ note.description }}</p>
              <router-link :to="'/notes/' + note._id.$oid" class="btn btn-outline-warning">Details</router-link>
              <button class="btn btn-outline-dark" @click="deleteNote(note._id)">Delete note</button>
              <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#staticBackdrop" @click="getSharedFriends(note._id)">Share note</button>
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
                        <input class="form-check-input" type="checkbox" :value="friend.id.$oid" :id="friend.name" v-model="friendsToShare" :checked="noteAlreadyShared(friend.id.$oid)">
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
            <button type="button" class="btn btn-warning" data-bs-dismiss="modal" @click="shareNote()">Share</button>
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
      friendsListWithId: [],
      sharedNoteId: null,
      friendsToShare: [],
      sharedFriendsList: [],

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
    async getFriendsWithId() {
      const res = await axios.get(config.getFriendsWithIdURL, {withCredentials: true});
      this.friendsListWithId = res.data;
    },
    async getSharedFriends(id) {
      this.sharedNoteId = id;

      const res = await axios.get(config.getSharedFriendsURL  + this.sharedNoteId.$oid + '/shared_with', {withCredentials: true});
      this.sharedFriendsList = res.data;
      console.log(this.sharedFriendsList);

      this.getUnsharedFriends();
    },
    shareNote() {

      axios.post(config.updateSharingNotesURL + this.sharedNoteId.$oid + '/sharing_update', {'shared_with': this.friendsToShare}, {withCredentials: true})
          .then(() => console.log('Hurraa!'))
          .catch(err => console.log(err));

      this.friendsToShare = [];
      this.sharedFriendsList = [];
      this.sharedNoteId = null;
    },
    noteAlreadyShared(id) {
      if (this.sharedFriendsList.some(friend => friend.id.$oid === id)) {
        return true;
      }
      return false;
    }
  },

  mounted() {
    this.getNotes();
    this.getFriendsWithId();
  }
}
</script>

<style scoped>

</style>