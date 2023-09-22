<template>
  <main class="banner">
  <section class="home__banner">
    <div class="home__banner__arrow left" @click="
      changeImage(
        currentImageIndex - 1 >= 0 ? currentImageIndex - 1 : images.length - 1
      )
      ">
      <i class="fas fa-chevron-left"></i>
    </div>
    <div>
      <transition name="fade" mode="out-in">
        <img :key="currentImage" :src="currentImage" alt="Carrousel de imagenes" />
      </transition>
    </div>
    <div class="home__banner__arrow right" @click="changeImage((currentImageIndex + 1) % images.length)">
      <i class="fas fa-chevron-right"></i>
    </div>
    <div class="home__banner__buttons">
      <div v-for="(image, index) in images" :key="index" :class="{
        home__banner__button: true,
        'home__banner__button-active': index === currentImageIndex,
      }" @click="changeImage(index)"></div>
    </div>
    <div class="home__banner__text">
      <transition name="fade" mode="out-in">
        <h1 v-if="currentImageIndex === 0">
          Una experiencia culinaria saludable.
        </h1>
        <h1 v-else-if="currentImageIndex === 1">
          El placer de comer bien cada día.
        </h1>
        <h1 v-else>Viandas frescas, hechas con amor</h1>
      </transition>
      <transition name="fade" mode="out-in">
        <p v-if="currentImageIndex === 0">
          Sisviansa es un oasis culinario donde se fusiona la pasión por la
          comida saludable y el arte gastronómico. Cada vianda es una obra
          maestra elaborada con ingredientes frescos y de alta calidad.
        </p>
        <p v-else-if="currentImageIndex === 1">
          En un mundo acelerado y lleno de compromisos, encontrar tiempo para
          preparar comidas saludables y equilibradas es un desafío. Sin embargo,
          en Viandas Sisviansa hacemos que esta tarea sea una experiencia
          placentera y conveniente para ti.
        </p>
        <p v-else>
          En Sisviansa, creemos que la comida es más que simplemente
          alimentarse, es una expresión de amor y cuidado hacia nosotros mismos
          y hacia quienes nos rodean. Por eso, nos enorgullece presentarte
          nuestras viandas frescas, elaboradas con un toque especial de amor en
          cada paso del proceso.
        </p>
      </transition>
    </div>
  </section>
</main>
</template>

<script>
export default {
  name: "HomeBanner",
  data() {
    return {
      images: [
        require("../../assets/imgs/homepage-banner1.png"),
        require("../../assets/imgs/homepage-banner2.png"),
        require("../../assets/imgs/homepage-banner3.png"),
      ],
      currentImageIndex: 0,
    };
  },
  computed: {
    currentImage() {
      return this.images[this.currentImageIndex];
    },
  },
  mounted() {
    this.startCarousel();
  },
  methods: {
    startCarousel() {
      setInterval(() => {
        this.nextImage();
      }, 20000);
    },
    nextImage() {
      this.currentImageIndex =
        (this.currentImageIndex + 1) % this.images.length;
    },
    changeImage(index) {
      this.currentImageIndex = index;
    },
  },
};
</script>
<style scoped>
.fade-enter-active,
.fade-leave-active {
  opacity: 0;
  transition-property: opacity;
  transition-duration: .5s;
  transition-timing-function: cubic-bezier(0.25, 0.1, 0.25, 1);
}
</style>
<style lang="css" src="./Carrousel.css" scoped></style>
