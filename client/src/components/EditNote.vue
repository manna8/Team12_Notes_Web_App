<template>
  <div>
    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: auto; height: auto">
      <h2 class="text-center text-warning">{{ note.title }}</h2>
      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="title">Change Title</label>
        <input type="text" class="form-control" placeholder="Enter title" v-model="note.title">
        <p class="text-warning text-opacity-75" v-if="!titleValid">Provide a title!</p>
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="description">Your note description:</label>
        <textarea type="text" class="form-control"  placeholder="Enter description" style="resize: none; height: 100px" v-model="note.description"></textarea>
        <p class="text-warning text-opacity-75" v-if="!descValid">Provide a description!</p>
      </div>

      <div class="mb-3 d-flex flex-column align-items-start" v-if="collections.length !== 0">
        <div>Selected collection: {{ originalCollection.title}}</div>

        <select v-model="input.selectedCollection">
          <option></option>
          <option v-for="collection in collections" :value="collection._id" :key="collection._id">{{ collection.title }}</option>
        </select>
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="formFile" class="form-label">Upload Image</label>
        <input accept="image/*" class="form-control" type="file" id="formFile" @change="uploadFile">
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-outline-dark" @click.prevent="changeNote">Apply Changes</button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "EditNote",

  data() {
    return {
      id: '',
      note: [],
      collections: [],
      originalCollection: [],

      input: {
        title: "",
        description: "",
        fileName: "",
        selectedImageURL: "",
        selectedFile : null,
        encodedFile: null,
        selectedCollection: ""
      },
    }
  },
  methods: {
    async getNote() {
      const res = await axios.get(config.getNoteURL + this.id, {withCredentials: true});
      this.note = res.data;

      await this.getCollection(this.note.notes_collection_id.$oid);
    },
    async getCollections() {
      const res = await axios.get(config.getCollectionsURL, {withCredentials: true});
      this.collections = res.data;
      console.log(this.collections);
    },
    titleValid() {
      return this.note.title !== "";
    },
    descValid() {
      return this.note.description !== "";
    },

    changeNote() {
      const formData = new FormData();
      formData.append('image', this.input.encodedFile);

      if (this.input.selectedCollection !== "") {
        this.input.selectedCollection = this.input.selectedCollection.$oid;
      }

      if (typeof this.input.selectedCollection === 'undefined') {
        this.input.selectedCollection = "";
      }

      if (this.titleValid() && this.descValid()) {
        if (this.input.encodedFile === null) {
          axios.post(config.updateNoteURL + this.id, {
            "id": this.id,
            "title": this.note.title,
            "description": this.note.description,
            "notes_collection_id": this.input.selectedCollection,
          }, {withCredentials: true}).then(res => console.log(res))
              .then(() => this.$router.push({path: '/notes'}))
              .catch(err => console.log(err.message));
        } else {
          axios.post(config.updateNoteURL + this.id, {
            "id": this.id,
            "title": this.note.title,
            "description": this.note.description,
            "photo": this.input.encodedFile.split(',')[1] // Get the base64 string from the encoded file
          }, {withCredentials: true}).then(res => console.log(res))
              .then(() => this.$router.push({path: '/notes'}))
              .catch(err => console.log(err.message));
        }
      }
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
      async getCollection(id) {
        const res = await axios.get(config.getCollectionURL + id, {withCredentials: true});
        this.originalCollection = res.data.notes_collection;
      },
  },
  created() {
    this.id = this.$route.params.id;
    this.getNote();
    this.getCollections();
  }
}
</script>

<style scoped>

</style>