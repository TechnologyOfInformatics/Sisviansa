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
  mounted() {
    setTimeout(() => {
      window.scrollTo({
        top: 0,
        behavior: "smooth",
      });
    }, 0);
  },
};
</script>
