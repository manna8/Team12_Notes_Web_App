<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4" v-if="collections.length !== 0" style="width: auto; height: auto">
        <ul v-for="collection in collections" v-bind:key="collection.title">
          <div class="col">
            <div class="card" style="max-width: 18rem; background-color: #404040">
              <div class="card-body">
                <li class="list-group-item">
                  <h4 class="text-white">{{ collection.title }}</h4>
                  <router-link :to="'/collections/' + collection._id.$oid" class="btn btn-warning">Details</router-link>
                  <button class="btn btn-outline-warning" @click="deleteCollection(collection._id)">Delete Collection</button>
                  <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#staticBackdrop" @click="getSharedFriends(collection._id)">Share collection</button>
                </li>
              </div>
            </div>

          </div>
        </ul>
      </div>
      <div class="container p-3 my-3 border mx-auto mb-3 mt-5 border-dark rounded text-center" v-else>
        <h3>You don't have any collections yet!</h3>
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
            <h4 class="border-warning">Stop sharing collection with:</h4>
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
              <h5>You are not sharing this collection :(</h5>
            </div>
          </div>
          <div class="modal-body">
            <h4>Share collection with:</h4>
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
            <button type="button" class="btn btn-warning" data-bs-dismiss="modal" @click="shareCollection()">Share</button>
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
  name: "CollectionsList",

  props: {
    id: String,
    title: String,
    description: Number
  },

  data() {
    return {
      collections: [],
      friendsListWithId: [],
      sharedCollectionId: null,
      friendsToShare: [],
      sharedFriendsList: [],
      toStopSharing: [],
      besidesSharing: [],
      finalList: []
    }
  },
  methods: {
    deleteCollection(id) {
      axios.delete(config.deleteCollectionURL + id.$oid, {withCredentials: true})
          .then(() => this.getCollections())
          .catch(err => console.log(err.message));
    },
    async getCollections() {
      const res = await axios.get(config.getCollectionsURL, {withCredentials: true});
      this.collections = res.data;
      console.log(this.collections);
    },
    async getFriendsWithId() {
      const res = await axios.get(config.getFriendsWithIdURL, {withCredentials: true});
      this.friendsListWithId = res.data;
    },
    async getSharedFriends(id) {
      this.sharedCollectionId = id;

      const res = await axios.get(config.getSharedFriendsColURL  + this.sharedCollectionId.$oid + '/shared_with', {withCredentials: true});
      this.sharedFriendsList = res.data;

      this.getBesidesSharing();

      console.log(this.besidesSharing);
    },
    shareCollection() {
      this.createFinalList();

      axios.post(config.updateSharingCollectionsURL + this.sharedCollectionId.$oid + '/sharing_update', {'shared_with': this.finalList}, {withCredentials: true})
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
      this.sharedCollectionId = null;
      this.finalList = [];
    }
  },
  mounted() {
    this.getCollections();
    this.getFriendsWithId();
  }
}
</script>

<style scoped>

</style>