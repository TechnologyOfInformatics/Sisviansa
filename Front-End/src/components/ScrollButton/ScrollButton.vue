<template>
  <div>
    <transition name="fade">
      <button v-if="showButton" @click="scrollToTop" class="scroll-button">
        <i class="fa-solid fa-chevron-up"></i>
      </button>
    </transition>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showButton: false,
    };
  },
  mounted() {
    window.addEventListener("scroll", this.handleScroll);
  },
  beforeUnmount() {
    window.removeEventListener("scroll", this.handleScroll);
  },
  methods: {
    handleScroll() {
      this.showButton = window.pageYOffset > 400;
    },
    scrollToTop() {
      window.scrollTo({
        top: 0,
        behavior: "smooth",
      });
    },
  },
};
</script>

<style>
.scroll-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-color: #243328;
  color: #fff;
  border: none;
  outline: none;
  cursor: pointer;
  opacity: 0.8;
  transition: opacity 0.3s ease;
  font-size: 2em;
  box-shadow: 0px 4px 6px rgba(255, 255, 255, 0.4);
}

.scroll-button:hover {
  opacity: 1;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
