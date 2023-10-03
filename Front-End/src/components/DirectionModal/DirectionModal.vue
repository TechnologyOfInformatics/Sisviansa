<template>
    <div v-show="isDirectionModalVisible">
        <div class="direction-modal" :style="{ transform: `translate(2vw, -${translateY}vh)` }">

            <div class="direction-modal-content">

                <p>hola</p>

                <button class="close-button" @click="toggleDirectionModal">
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
        toggleDirectionModal() {
            this.$emit("toggle-direction-modal");
        },
        handleScroll() {
            const scrollThreshold = 2.5 * window.innerHeight / 100; 

            if (!this.hasScrolled && window.scrollY >= scrollThreshold) {
                this.translateY += 4;
                this.hasScrolled = true;
            } else if (this.hasScrolled && window.scrollY < scrollThreshold) {
                this.translateY -= 4;
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
  