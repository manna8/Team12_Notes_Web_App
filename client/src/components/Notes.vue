<template>
<div id="notes">

<!--    <h2>You don't have any notes yet!</h2>-->

    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 450px">
      <h2 class="text-center text-warning">Add new note!</h2>
      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="title">Title</label>
        <input type="text" class="form-control" v-model="input.title" placeholder="Enter title">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="description">Description</label>
        <input type="text" class="form-control" v-model="input.description" placeholder="Enter description">
      </div>

      <div class="text-center">
        <button type="submit" class="btn btn-outline-dark" @click="addNote">Create Note</button>
      </div>

    </form>

  <div>
  <NotesList></NotesList>
  </div>

</div>
</template>

<script>
import NotesList from "@/components/NotesList.vue";

export default {
  name: "Notes",

  data() {
    return {
      input: {
        title: "",
        description: ""
      },
    };
  },
  components: {
    NotesList
  },
  methods: {
    addNote() {

    }
  }
}
</script>

<style scoped>

</style>