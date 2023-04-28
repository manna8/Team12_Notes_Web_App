<template>
  <div>
    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" v-bind:style="[isMobile() ? styleMobile : styleWeb]">
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
        <div>Selected collection: </div>

        <select v-model="input.selectedCollection">
          <option></option>
          <option v-for="collection in collections" :value ="collection._id" :key="collection._id">{{ collection.title }}</option>
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
import config from "../../../config/config";

export default {
  name: "AddNote",

  data() {
    return {
      collections: [],

      styleWeb: {
        width: '400px',
        height: 'auto'
      },
      styleMobile: {
        width: '300px',
        height: 'auto'
      },
      input: {
        title: "",
        description: "",
        fileName: "",
        selectedImageURL: "",
        selectedFile : null,
        encodedFile: null,
        selectedCollection: null
      },
    };
  },

  methods: {
    async getCollections() {
      const res = await axios.get(config.getCollectionsURL, {withCredentials: true});
      this.collections = res.data;
    },
    async uploadFile(event) {
      this.selectedFile = event.target.files[0];

      const reader = new FileReader();
      reader.readAsDataURL(this.selectedFile);

      await new Promise((resolve) => {
        reader.onload = () => {
          this.input.encodedFile = reader.result;
          resolve();
        };
      });
    },
    addNote() {
      const formData = new FormData();
      formData.append('image', this.input.encodedFile);

      if (this.input.selectedCollection !== null) {
        this.input.selectedCollection = this.input.selectedCollection.$oid;
      }

      if (this.titleValid() && this.descValid()) {
        if (this.input.encodedFile !== null) {
          axios.post(config.addNoteURL, {
            "title": this.input.title,
            "description": this.input.description,
            "notes_collection_id": this.input.selectedCollection,
            "photo": this.input.encodedFile.split(',')[1] // Get the base64 string from the encoded file
          }, {withCredentials: true})
              .then(() => this.$router.push({path: '/notes'}))
              .catch(err => console.log(err.message));
        } else {
          axios.post(config.addNoteURL, {
            "title": this.input.title,
            "description": this.input.description,
            "notes_collection_id": this.input.selectedCollection,
            "photo": {}
          }, {withCredentials: true})
              .then(() => this.$router.push({path: '/notes'}))
              .catch(err => console.log(err.message));
        }
      }
    },
    titleValid() {
      return this.input.title !== "";
    },
    descValid() {
      return this.input.description !== "";
    },
    isMobile() {
      return screen.width < 500;
    }
  },

    mounted() {
      this.getCollections();
    }
  }

</script>

<style scoped>

</style>