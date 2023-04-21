<template>
<div id="notes">
  <div class="container">

    <div class="row ms-auto">
      <div class="col">
        <div  class="d-grid">
          <br>
          <button class="btn btn-warning">
            <router-link class="nav-link" to="/createNote">Create Note</router-link>
          </button>
        </div>
      </div>
    </div>

    <br>

    <div class="row ms-auto">
      <div class="col">
        <div  class="d-grid">
          <div class="btn-group" role="group" aria-label="Basic outlined example">
            <button type="button" class="btn btn-dark btn-outline-warning">Your notes</button>
            <button type="button" class="btn btn-dark btn-outline-warning">Notes shared with you</button>
            <button type="button" class="btn btn-dark btn-outline-warning">Notes you are sharing</button>
          </div>
        </div>
      </div>
    </div>

    <br>
    <div class="row ms-auto overflow-auto" style="height: 500px">
      <div class="col h-100 d-inline-block">
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

    };
  },
  components: {
    NotesList,
  }
}
</script>

<style scoped>

</style>