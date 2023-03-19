<template>
  <div>
    <div class="overflow-auto">
      <div class="row row-cols-1 row-cols-md-3 g-4">
      <ul v-for="(note, index) in notes" v-bind:key="note.title">
        <div class="col">
        <div class="card" style="width: 18rem;">
          <img src="../assets/background2.png" class="card-img-top" alt="image :/">
          <div class="card-body">
            <h5 class="note-title">{{ note.title }}</h5>
            <p class="note-text">{{ note.description }}</p>
            <a href="#" class="btn btn-warning">Details</a>
            <button class="btn btn-outline-dark" @click="deleteNote(index)">Delete note</button>
          </div>
        </div>
        </div>
      </ul>
      </div>
    </div>
  </div>

</template>

<script>
export default {
  name: "NotesList",
  props: {
    title: String,
    description: Number
  },

  data() {
    return {

      notes: [
        {title: 'Shopping',
          description: 'My shopping list'},

        {title: 'Gifts',
          description: 'Gift ideas'
        },
        {title: 'Gifts',
          description: 'Gift ideas'
        },
        {title: 'Gifts',
          description: 'Gift ideas'
        },
        {title: 'Gifts',
          description: 'Gift ideas'
        },
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