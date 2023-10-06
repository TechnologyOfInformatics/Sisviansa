<template>
    <div v-show="isDirectionModalVisible">
        <div class="direction-modal" :style="{ transform: `translate(2vw, -${translateY}vh)` }">

            <div class="direction-modal-content">
                <div v-if="this.directions.length === 0" class="empty-direction-message directions-container">
                    <span>Usted no tiene direcciones</span> <br>
                    <span>Puedes añadir una en </span><router-link to="/profile" class="link">tú perfil</router-link>

                </div>
                <div v-else>
                    <div class="directions-container">
                        <ul class="direction-list">
                            <li v-for="(direction, index) in directions" :key="index" class="direction-list-item">
                                <div>
                                    <p>Ciudad:</p>
                                    {{ direction.ciudad }}<br>

                                    <p>Barrio:</p> {{ direction.barrio }}
                                </div>
                                <div>

                                    <p>Calle:</p> {{ direction.calle }}<br>
                                    <p>Número:</p> {{ direction.numero }}
                                </div>


                            </li>
                        </ul>
                        <p class="direction-link">Modifica tus direcciones, <router-link to="/profile"
                                class="link">aquí</router-link>.</p>
                    </div>
                </div>

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
        isDirectionModalVisible: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            translateY: 10,
            hasScrolled: false,
            directions: [],
        };
    },
    created() {
        this.fetchUserData();
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
        fetchUserData() {
            const dataToSend = {
                functionName: "options_get_address",
                token: sessionStorage.getItem('miToken') || 0,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    this.directions = response.data;

                })
                .catch((error) => {
                    console.error(error);
                });
        },

    },
    mounted() {
        window.addEventListener("scroll", this.handleScroll);
    },
};
</script>
  
  
<style lang="css" src="./DirectionModal.css" scoped></style>
  