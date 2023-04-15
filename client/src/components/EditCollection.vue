<template>
<div>
  <h2>{{ collection.title }}</h2>
</div>
</template>

<script>
import axios from "axios";
import config from "../../config/config";

export default {
  name: "EditCollection",

  data() {
    return {
      id: '',
      collection: []
    }
  },
  methods: {
    async getCollection() {
      const res = await axios.get(config.getCollectionURL + this.id, {withCredentials: true});
      this.collection = res.data;
    },
  },
  created() {
    this.id = this.$route.params.id;
    this.getCollection();
  }
}
</script>

<style scoped>

</style>