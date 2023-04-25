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
            <h4 class="border-warning">Stop sharing note with:</h4>
            <div class="container" v-if="sharedFriendsList.length !== 0">
              <ul class="list-group" v-for="friend in sharedFriendsList" v-bind:key="friend.id.$oid">
                <li class="list-group-item">

                  <div class="input-group">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" :value="friend.id.$oid" :id="friend.id.$oid" v-model="toStopSharing">
                      <label class="form-check-label" for="flexCheckDefault">
                        <h5>{{ friend.name }}</h5>
                      </label>

                    </div>
                  </div>
                </li>
              </ul>
            </div>
            <div v-else>
              <h5>You are not sharing this note :(</h5>
            </div>
          </div>
          <div class="modal-body">
            <h4>Share note with:</h4>
            <div class="container" v-if="besidesSharing.length !== 0">
              <ul class="list-group" v-for="friend in besidesSharing" v-bind:key="friend.id.$oid">
                <li class="list-group-item">

                  <div class="input-group">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" :value="friend.id.$oid" :id="friend.id.$oid" v-model="friendsToShare">
                      <label class="form-check-label" for="flexCheckDefault">
                        <h5>{{ friend.name }}</h5>
                      </label>

                    </div>
                  </div>
                </li>
              </ul>
            </div>

            <div v-else>
              <h5>You don't have more friends</h5>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" @click="closePopup()">Close</button>
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
      toStopSharing: [],
      besidesSharing: [],
      finalList: []
    };
  },

  methods: {
    deleteNote(id) {
      axios.delete(config.deleteNotesURL + id.$oid, {withCredentials: true})
          .then(() => this.getNotes())
          .catch(err => console.log(err.message));
    },
    async getNotes() {
      const res = await axios.get(config.getSharingNotesURL, {withCredentials: true});
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

      this.getBesidesSharing();
    },
    shareNote() {
      this.createFinalList();

      axios.post(config.updateSharingNotesURL + this.sharedNoteId.$oid + '/sharing_update', {'shared_with': this.finalList}, {withCredentials: true})
          .then(() => console.log('Hurraa!'))
          .catch(err => console.log(err));

      this.closePopup();
    },

    getBesidesSharing() {

      const friendsList = Array.from(this.friendsListWithId);
      const sharedList = Array.from(this.sharedFriendsList);

      this.besidesSharing = friendsList.filter(value => !sharedList.some(friend => JSON.stringify(friend) === JSON.stringify(value)));
      this.besidesSharing = new Proxy(this.besidesSharing, {});

    },
    createFinalList() {
      const stopList = Array.from(this.toStopSharing);
      let sharedList = Array.from(this.sharedFriendsList);
      const toShareList = Array.from(this.friendsToShare);

      sharedList = sharedList.map(obj => obj.id?.$oid || obj.id);

      let stillShareWith = sharedList.filter(value => !stopList.some(friend => JSON.stringify(friend) === JSON.stringify(value)));
      stillShareWith = new Proxy(stillShareWith, {});

      let ids = Object.values(stillShareWith).map(obj => obj.id?.$oid || obj);
      let combinedList = new Set([...ids, ...toShareList]);
      this.finalList = new Proxy([...combinedList], {});


    },
    closePopup() {
      this.friendsToShare = [];
      this.toStopSharing = [];
      this.sharedFriendsList = [];
      this.besidesSharing = [];
      this.sharedNoteId = null;
      this.finalList = [];
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