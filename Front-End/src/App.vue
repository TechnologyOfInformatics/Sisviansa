<template>
  <div id="app">
    <LoaderSpinner />
    <router-view />
  </div>
</template>

<script>
import LoaderSpinner from "@/components/Loader/Loader.vue";

export default {
  name: "App",
  components: {
    LoaderSpinner,
  },
};
</script>
