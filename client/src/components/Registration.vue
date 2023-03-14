<template id="register">
  <div id="register">

    <form class="container p-3 my-3 border bg-light mx-auto mb-3 mt-5 border-warning rounded" style="width: 450px; height: 450px">
      <h2 class="text-center text-warning">Register!</h2>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="email">Email</label>
        <input type="text" class="form-control" placeholder="Enter email">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="username">Username</label>
        <input type="text" class="form-control" placeholder="Enter username">
      </div>

      <div class="mb-3 d-flex flex-column align-items-start">
        <label for="password">Password</label>
        <input type="password" class="form-control" placeholder="Enter password">
      </div>

      <p>Already have an account?
        <router-link to="/" class="link-warning">Login!</router-link>
      </p>

      <div class="text-center">
        <button type="submit" class="btn btn-outline-dark">Register!</button>
      </div>

    </form>
  </div>
</template>

<script>
export default {
  name: "Registration"
}
</script>

<style scoped>

</style>