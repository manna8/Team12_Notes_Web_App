<template>
  <div>
    <div class="container">
      <br>

        <h2 class="text-center">
          Welcome to MindNote!
        </h2>

      <div class="container p-3 my-3 border bg-secondary-subtle mx-auto mb-3 mt-5 border-warning rounded" style="width: 700px; height: auto">
        <p>Welcome home to MindNote, your personal space for organizing your thoughts and ideas! We're thrilled to have you back and can't wait to see all the amazing notes you'll create. Whether you're jotting down a quick reminder or drafting a complex project plan, MindNote is here to help you keep everything in one place.

          With MindNote, you can easily create, edit, and organize notes in a way that makes sense to you. By using collections, you can customize MindNote to fit your unique workflow. And with our seamless syncing across devices, you can access your notes from anywhere, at any time.

          So go ahead, make yourself at home in MindNote. We're here to help you stay organized, productive, and inspired.</p>
      </div>

      <div  class="d-grid gap-2 col-6 mx-auto"  v-if="!isLogged">
        <button class="btn btn-warning" type="button">
          <router-link class="nav-link" to="/login">Login</router-link>
        </button>
        <button class="btn btn-warning" type="button">
          <router-link class="nav-link" to="/register">Register</router-link>
        </button>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  name: "Home",

  computed: {
    isLogged() {
      return this.$store.state.loggedIn;
    }
  }
}
</script>

<style scoped>

</style>