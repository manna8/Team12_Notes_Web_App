<template id="app">
  <MainMenu/>
  <div class="d-flex justify-content-center">
    <main>
      <router-view></router-view>
    </main>
  </div>

</template>

<script>
import MainMenu from "@/components/MainMenu.vue";

export default {
  name: 'app',
  components: {
    MainMenu
  }
}
</script>

<style>

#app {
  background-image: url("@/assets/background4.png");
}

</style>
