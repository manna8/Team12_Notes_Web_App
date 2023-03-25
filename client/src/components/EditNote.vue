<template>
  <div>
    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: auto">
      <h2 class="text-center text-warning">{{ note.title }}</h2>
      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="title">Change Title</label>
        <input type="text" class="form-control" placeholder="Enter title" v-model="note.title">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="description">Your note description:</label>
        <textarea type="text" class="form-control"  placeholder="Enter description" style="resize: none; height: 100px" v-model="note.description"></textarea>
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
      note: []
    }
  },
  methods: {
    async getNote() {
      const res = await axios.get(config.getNoteURL + this.id, {withCredentials: true});
      this.note = res.data;
    },

    changeNote() {
      axios.post(config.updateNoteURL + this.id,{
        "id": this.id,
        "title": this.note.title,
        "description": this.note.description
      },{withCredentials: true}).then(res => console.log(res))
          .then(() => this.$router.push({path: '/notes'}))
          .catch(err => console.log(err.message));
    }
  },
  created() {
    this.id = this.$route.params.id;
    this.getNote();
  }
}
</script>

<style scoped>

</style>