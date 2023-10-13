<template>
    <main>
        <div class="directions-container">
            <ul class="direction-list" v-if="Array.isArray(this.directions)">
                <li v-for="(direction, index) in directions" :key="index" class="direction-list-item">

                    <div class="direction">
                        <div class="direction-button gears">
                            <i class="fa-solid fa-gears"></i>
                        </div>
                        <div class="direction-item"> <i class="fa-solid fa-route"></i>

                            <p class="direction-item-city">{{ direction.ciudad }}</p>
                            <i class="fa-solid fa-house-flag"></i>
                            <div>
                                <p> {{ direction.barrio }}, {{ direction.calle }} {{ direction.direccion }}</p>
                            </div>
                        </div>
                        <div class="direction-button trash">
                            <i class="fa-solid fa-trash"></i>
                        </div>
                    </div>
                </li>
                <li v-for="n in 3 - directions.length" :key="n" class="direction-item-null">
                    <DirectionProfileButton />
                </li>
            </ul>
        </div>
        <button @click="showAddAddressModal = true">Agregar Dirección</button>
        <div v-if="showAddAddressModal" class="modal">
            <div class="modal-content">
                <input type="text" v-model="newAddress.ciudad" placeholder="Ciudad">
                <input type="text" v-model="newAddress.barrio" placeholder="Barrio">
                <input type="text" v-model="newAddress.calle" placeholder="Calle">
                <input type="text" v-model="newAddress.direccion" placeholder="Dirección">
                <button @click="addNewAddress">Guardar</button>
                <button @click="showAddAddressModal = false">Cancelar</button>
            </div>
        </div>
    </main>
</template>
  
<script>

import DirectionProfileButton from '@/components/DirectionProfileButton/DirectionProfileButton.vue'
export default {
    name: "ProfileDirection",
    components: {
        DirectionProfileButton
    },
    data() {
        return {
            directions: [],
            showAddAddressModal: false,
            newAddress: {
                ciudad: '',
                barrio: '',
                calle: '',
                direccion: '',
            },
        };
    },
    created() {
        this.fetchUserData();
    },
    methods: {
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
        addNewAddress() {

            if (this.directions.length > 2) {
                console.log("exceso")
                return;
            }

            const dataToSend = {
                functionName: "options_set_address",
                token: sessionStorage.getItem('miToken') || 0,
                address: this.newAddress,
            };
            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response)
                    this.showAddAddressModal = false;
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
  
  
<style lang="css" src="./ProfileDirection.css" scoped></style>
  