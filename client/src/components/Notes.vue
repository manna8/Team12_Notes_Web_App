<template>
<div id="notes">
  <div class="container">
    <div class="row ms-auto">

      <div class="col">
        <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 350px">
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

      <div class="col">
        <div>
          <NotesList></NotesList>
        </div>
      </div>

    </div>
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