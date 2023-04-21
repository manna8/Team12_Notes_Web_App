<template>
  <div>
    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: auto">
      <h2 class="text-center text-warning">Add new note!</h2>
      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="title">Title</label>
        <input type="text" class="form-control" v-model="input.title" placeholder="Enter title">
        <p class="text-warning text-opacity-75" v-if="!titleValid">Provide a title!</p>
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="description">Description</label>
        <textarea type="text" class="form-control" v-model="input.description" placeholder="Enter description" style="resize: none; height: 100px"></textarea>
        <p class="text-warning text-opacity-75" v-if="!descValid">Provide a description!</p>
      </div>

      <div class="mb-3 d-flex flex-column align-items-start" v-if="collections.length !== 0">
        <div>Selected collection: {{ input.selectedCollection }}</div>

        <select v-model="input.selectedCollection">
          <option></option>
          <option v-for="collection in collections" :key="collection.title">{{ collection.title }}</option>
        </select>
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
          <label for="formFile" class="form-label">Upload Image</label>
          <input accept="image/*" class="form-control" type="file" id="formFile" @change="uploadFile">
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-outline-dark" @click.prevent="addNote">Create Note</button>
      </div>
    </form>
  </div>

</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "AddNote",

  data() {
    return {
      collections: [],

      input: {
        title: "",
        description: "",
        fileName: "",
        selectedImageURL: "",
        selectedImageData: null,
        selectedCollection: ""
      },
    };
  },
  methods: {
    addNote() {
      if (this.titleValid() && this.descValid()) {
        console.log(this.input.selectedCollection);

        axios.post(config.addNoteURL, {
          "title": this.input.title,
          "description": this.input.description,
          "photo_url": this.input.selectedImageURL
        }, {withCredentials: true})
            .then(() => this.$router.push({path: '/notes'}))
            .catch(err => console.log(err.message));
      }
    },
    async uploadFile(event) {
      const file = event.target.files[0];
      const accessToken = 'sl.Bcp1GgNyV7HKbbYCJlmIN-0-sA7Cnc8Ev0TEYQ3KNjpnrFs5lCQedHpHUDsYYRA7J6UcrDYPxTdDvKdL7gccMw9DgIba0-DTKbovKx052Cuyqz7ty2WrgQ0vNWM9O9xzFQJqUksg9CDG';
      const url = 'https://content.dropboxapi.com/2/files/upload';
      const headers = {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/octet-stream',
        'Dropbox-API-Arg': JSON.stringify({
          path: `/mindnote/${file.name}`,
          mode: 'add',
          autorename: false,
          mute: false,
          strict_conflict: false
        })
      };
      const response = await axios.post(url, file, { headers });
      console.log(response.data);

      const sharingUrl = 'https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings';
      const sharingHeaders = {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      };
      const sharingData = {
        path: response.data.path_display
      };
      const sharingResponse = await axios.post(sharingUrl, sharingData, { headers: sharingHeaders });

      // Use the shared link URL in your application
      const imageUrl = sharingResponse.data.url;
      this.input.selectedImageURL = imageUrl;
    },
    titleValid() {
      if (this.input.title === "") {
        return false;
      } else {
        return true;
      }
    },
    descValid() {
      if (this.input.description === "") {
        return false;
      } else {
        return true;
      }
    },

    async getCollections() {
      const res = await axios.get(config.getCollectionsURL, {withCredentials: true});
      this.collections = res.data;
      console.log(this.collections);
    },
  },
    mounted() {
      this.getCollections();
    }
  }

</script>

<style scoped>

</style>