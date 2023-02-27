<template>
<div id="note">
  <div class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" v-if="notes.length < 1">
    <h2>You don't have any notes yet!</h2>

    <div class="text-center">
      <button class="btn btn-outline-dark">Add new note</button>
    </div>
  </div>
  <div v-else>
    <ul v-for="(note, index) in notes" v-bind:key="note.title">
      <div class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded">
        <h3>{{ note.title }}</h3>
        <h5>{{ note.description }}</h5>

        <div class="text-center">
          <button class="btn btn-outline-dark" @click="deleteNote(index)">Delete note</button>
        </div>
      </div>

    </ul>
  </div>

</div>
</template>

<script>
export default {
  name: "Notes",

  data() {
    return {
      notes: [
        {title: 'Shopping',
        description: 'My shopping list'},

        {title: 'Gifts',
          description: 'Gift ideas'
        }
      ]
    };
  },
  methods: {
    deleteNote(idx) {
      this.notes.splice(idx, 1);
    }
  }
}
</script>

<style scoped>

</style>