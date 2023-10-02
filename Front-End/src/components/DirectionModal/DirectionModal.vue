<template>
    <div v-show="isDirectionModalVisible">
        <div class="direction-modal" :style="{ transform: `translate(2vw, -${translateY}vh)` }">

            <div class="direction-modal-content">







                <p>hola</p>















                <button class="close-button" @click="closeModal">
                    <i class="fa-solid fa-circle-xmark"></i>
                </button>
            </div>
        </div>
    </div>
</template>
  
<script>
export default {
    name: "DirectionModal",
    props: {
        cart: {
            type: Array,
            default: () => [],
        },
        isDirectionModalVisible: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            translateY: 10,
            hasScrolled: false,
        };
    },
    methods: {

        handleScroll() {
            const scrollThreshold = 2.5 * window.innerHeight / 100; // 5vh

            if (!this.hasScrolled && window.scrollY >= scrollThreshold) {
                this.translateY += 4; // El carrito sube a la posición inicial
                this.hasScrolled = true;
            } else if (this.hasScrolled && window.scrollY < scrollThreshold) {
                this.translateY -= 4; // El carrito baja nuevamente
                this.hasScrolled = false;
            }
        },

    },
    mounted() {
        window.addEventListener("scroll", this.handleScroll);
    },
};
</script>
  
  
<style lang="css" src="./DirectionModal.css" scoped></style>
  