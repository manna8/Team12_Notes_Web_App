<template>
<div id="notes">
  <div class="container">

    <div class="row ms-auto" v-if="!isAdmin">
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

    <div class="row ms-auto m-2">
      <div class="col">
        <div  class="d-grid">
          <div class="btn-group" role="group" aria-label="Basic outlined example">
            <button type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showUserNotes }" @click="toggleUserNotes">Your notes</button>
            <button v-if="!isAdmin" type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showSharedWithUserNotes  }" @click="toggleSharedNotes">Notes shared with you</button>
            <button v-if="!isAdmin" type="button" class="btn btn-dark btn-outline-white text-white" :class="{ active: showSharingNotes  }" @click="toggleSharingNotes">Notes you are sharing</button>
          </div>
        </div>
      </div>
    </div>

    <br>
    <div class="row ms-auto overflow-auto" style="height: 500px">
      <div class="col h-100 d-inline-block">
        <div v-if="showUserNotes">
          <NotesList></NotesList>
        </div>
        <div v-if="showSharingNotes">
          <SharingNotesList></SharingNotesList>
        </div>
        <div v-if="showSharedWithUserNotes">
          <SharedNotesList></SharedNotesList>
        </div>
      </div>
    </div>

  </div>
</div>
</template>

<script>
import NotesList from "@/components/NotesList.vue";
import SharingNotesList from "@/components/SharingNotesList.vue";
import SharedNotesList from "@/components/SharedNotesList.vue";

export default {
  name: "Notes",

  data() {
    return {
      showUserNotes: true,
      showSharedWithUserNotes: false,
      showSharingNotes: false,
    };
  },
  components: {
    NotesList,
    SharingNotesList,
    SharedNotesList
  },
  methods: {
    toggleUserNotes() {
      this.showUserNotes = !this.showUserNotes;

      if (this.showSharedWithUserNotes) {
        this.showSharedWithUserNotes = false;
      }

      if (this.showSharingNotes) {
        this.showSharingNotes = false;
      }
    },

    toggleSharedNotes() {
      this.showSharedWithUserNotes = !this.showSharedWithUserNotes;

      if (this.showUserNotes) {
        this.showUserNotes = false;
      }

      if (this.showSharingNotes) {
        this.showSharingNotes = false;
      }
    },

    toggleSharingNotes() {
      this.showSharingNotes = !this.showSharingNotes;

      if (this.showUserNotes) {
        this.showUserNotes = false;
      }

      if (this.showSharedWithUserNotes) {
        this.showSharedWithUserNotes = false;
      }
    }
  },
  computed: {
    isAdmin() {
      return this.$store.state.admin;
    }
  }

}
</script>

<style scoped>

</style>