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

      <div class="mb-3 d-flex flex-column align-items-start">
          <label for="formFile" class="form-label">Upload Image</label>
          <input accept="image/*" class="form-control" type="file" id="formFile" @change="uploadImage">
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
      input: {
        title: "",
        description: "",
        fileName: "",
        selectedImage: null,
      },
      titleValid: true,
      descValid: true
    };
  },
  methods: {
    addNote() {

      this.checkIfValid();

      if (this.titleValid && this.descValid) {
        axios.post(config.addNoteURL, {
          "title": this.input.title,
          "description": this.input.description
        }, {withCredentials: true})
            .then(() => this.$router.push({path: '/notes'}))
            .catch(err => console.log(err.message));
      }

      if (this.input.title !== '') {
        const imageData = new FormData();
        imageData.append("image", this.input.selectedImage, this.input.fileName);
        axios.post(config.addNoteURL, imageData)
            .then(res => console.log(res));
      }
    },
    uploadImage(event) {
      console.log(event);
    },
    checkIfValid() {
      if (this.input.title === "") {
        this.titleValid = false;
      } else {
        this.titleValid = true;
      }

      if (this.input.description === "") {
        this.descValid = false;
      } else {
        this.descValid = true;
      }
    }
  }
}
</script>

<style scoped>

</style>