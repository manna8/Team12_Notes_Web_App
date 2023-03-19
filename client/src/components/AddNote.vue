<template>
  <div>
    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 350px" @click.prevent>
      <h2 class="text-center text-warning">Add new note!</h2>
      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="title">Title</label>
        <input type="text" class="form-control" v-model="input.title" placeholder="Enter title">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="description">Description</label>
        <textarea type="text" class="form-control" v-model="input.description" placeholder="Enter description"></textarea>
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-outline-dark" @click="addNote">Create Note</button>
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
        description: ""
      },
    };
  },
  methods: {
    addNote() {
      if (this.input.title !== "" && this.input.description !== "") {
        axios.post(config.addNoteURL, {
          "title": this.input.title,
          "description": this.input.description
        }, {withCredentials: true})
            .then(() => this.$router.push({path: '/notes'}))
            .catch(err => console.log(err.message));
      }
    }
  }
}
</script>

<style scoped>

</style>