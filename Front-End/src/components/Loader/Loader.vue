<template>
  <div>
    <div v-if="loading" class="loading-overlay">
      <div class="loading-spinner"></div>
    </div>
  </div>
</template>

<script>
export default {
  name: "LoaderSpinner",
  data() {
    return {
      loading: false, // Estado inicial del loader
    };
  },
  methods: {
    showLoader() {
      this.loading = true;
    },
    hideLoader() {
      setTimeout(() => {
        this.loading = false;
      }, 300);
    },
  },
  mounted() {
    this.$router.beforeEach((to, from, next) => {
      this.showLoader();
      next();
    });

    this.$router.afterEach(() => {
      this.hideLoader();
    });
  },
};
</script>

<style scoped>
/* Estilos para el loader */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.95);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
}

.loading-spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 2s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>