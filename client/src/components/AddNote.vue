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
import { BlobServiceClient, StorageSharedKeyCredential } from '@azure/storage-blob';
// import { BlobServiceClient } from '@azure/storage-blob';

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
        selectedFile : null,
        selectedCollection: ""
      },
    };
  },

  methods: {
    addNote() {
      this.uploadImage();

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

      this.selectedFile = event.target.files[0];
    },

    async uploadImage() {
      // Create a BlobServiceClient object using your access key
      const accountName = 'notesapp3';
      const accountKey = 'q9bYYEIUH+2zKnwWgwj1Eif1WOCOY2eiWN9M9QpcrbXUJGNa2VMUXUVlIgLrsEE4Jzd4bP8ApyDH+AStN7j3Lw==';
      // const connectionString = 'DefaultEndpointsProtocol=https;AccountName=notesapp3;AccountKey=q9bYYEIUH+2zKnwWgwj1Eif1WOCOY2eiWN9M9QpcrbXUJGNa2VMUXUVlIgLrsEE4Jzd4bP8ApyDH+AStN7j3Lw==;EndpointSuffix=core.windows.net';

      const sharedKeyCredential = new StorageSharedKeyCredential(accountName, accountKey);

      const blobServiceClient = new BlobServiceClient(
          `https://${accountName}.blob.core.windows.net`,
          sharedKeyCredential
      );


      // const blobServiceClient = BlobServiceClient.fromConnectionString(connectionString);

      // Get a reference to the container where you want to store the images
      const containerName = 'notes-images';
      const containerClient = blobServiceClient.getContainerClient(containerName);

      // Generate a unique name for the image file
      const fileName = `${Date.now()}-${this.selectedFile.name}`;

      // Get a block blob client and upload the image file to Blob Storage
      // const blockBlobClient = containerClient.getBlockBlobClient(fileName);
      // await blockBlobClient.uploadData(this.selectedFile);

      const blob = new Blob([this.selectedFile], { type: this.selectedFile.type });

      // Get a block blob client and upload the image file to Blob Storage
      const blockBlobClient = containerClient.getBlockBlobClient(fileName);
      await blockBlobClient.uploadData(blob);

      // Save the URL to your database or use it to display the image on your app
      this.input.selectedImageURL = blockBlobClient.url;

      console.log(blockBlobClient.url);

    },

    titleValid() {
      return this.input.title !== "";
    },
    descValid() {
      return this.input.description !== "";
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