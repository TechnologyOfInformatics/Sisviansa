<template>
    <main>
        <div class="directions-container">
            <ul class="direction-list" v-if="Array.isArray(this.directions)">
                <li v-for="(direction, index) in directions" :key="direction.id" class="direction-list-item">
                    <div class="direction">
                        <div class="direction-button gears">
                            <i class="fa-solid fa-gears"></i>
                        </div>
                        <div class="direction-item" @click="addDefault(index)">
                            <i class="fa-solid fa-route"></i>
                            <p class="direction-item-city">{{ direction.ciudad }}</p>
                            <i class="fa-solid fa-house-flag"></i>
                            <div>
                                <p> {{ direction.barrio }}, {{ direction.calle }} {{ direction.direccion }}</p>
                            </div>
                        </div>
                        <div class="direction-button trash" @click="deleteAddress(index)">
                            <i class="fa-solid fa-trash"></i>
                        </div>
                        <div class="star">
                            <i class="fa-solid fa-star" v-if="direction.predeterminado == '1'"></i>
                        </div>
                    </div>
                </li>

                <li v-for="n in 3 - directions.length" :key="n" class="direction-item-null">
                    <DirectionProfileButton @click="showAddressModal" />
                </li>
            </ul>
        </div>
        <div v-if="addresModal" class="modal-overlay">
            <div class="modal">
                <div class="modal-content direction">
                    <div class="direction-item direction-item-modal">
                        <i class="fa-solid fa-route"></i>
                        <input type="text" v-model="newAddress.ciudad" placeholder="Ciudad">
                        <i class="fa-solid fa-house-flag"></i>
                        <div class="bottom-form">
                            <input type="text" v-model="newAddress.barrio" placeholder="Barrio">
                            <input type="text" v-model="newAddress.calle" placeholder="Calle">
                            <input type="text" v-model="newAddress.direccion" placeholder="Dirección">
                        </div>
                    </div>
                </div>
                <button @click="addNewAddress">Guardar</button>
                <button @click="showAddressModal">Cancelar</button>
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
            dir: [],
            addresModal: false,
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

        showAddressModal() {
            this.addresModal = !this.addresModal;
        },
        fetchUserData() {
            const dataToSend = {
                functionName: "options_get_address",
                token: sessionStorage.getItem('miToken') || 0,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response.data)
                    this.directions = response.data;

                })
                .catch((error) => {
                    console.error(error);
                });
        },
        addNewAddress() {
            console.log(this.directions)
            if (this.directions.length >= 3) {
                console.log("exceso")
                return;
            }


            const dataToSend = {
                functionName: "options_set_address",
                token: sessionStorage.getItem('miToken') || 0,
                ciudad: this.newAddress.ciudad,
                barrio: this.newAddress.barrio,
                calle: this.newAddress.calle,
                numero: this.newAddress.direccion
            };
            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response.data)
                    this.directions.push(this.newAddress)
                    this.addresModal = false;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        deleteAddress(index) {
            const addressId = this.directions[index].id;
            const dataToSend = {
                functionName: "options_delete_address",
                token: sessionStorage.getItem('miToken') || 0,
                id: addressId,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response);
                    this.directions.splice(index, 1);
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        addDefault(index) {
            const addressId = this.directions[index].id;
            const dataToSend = {
                functionName: "options_toggle_default",
                token: sessionStorage.getItem('miToken') || 0,
                id: addressId,
            };
            console.log(dataToSend.id)
            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    this.directions = response.data
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
  