<template>
    <main>
        <div class="directions-container">
            <ul class="direction-list" v-if="Array.isArray(this.directions)">
                <li v-for="(direction, index) in directions" :key="direction.id" class="direction-list-item">
                    <div class="direction">
                        <div class="direction-button edit" @click="showEditModal(index)">
                            <i class="fa-solid fa-pencil"></i>
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
                            <i class="fa-solid" v-if="direction.predeterminado == '1'">
                                <img src="../../assets/page-icons/star.png"
                                    alt="Estrella ilustrativa para mostrar la dirección predeterminada."
                                    class="fa-star"></i>
                        </div>
                    </div>
                </li>

                <li v-for="n in 3 - directions.length" :key="n" class="direction-item-null">
                    <DirectionProfileButton @click="showAddModal" />
                </li>
            </ul>
        </div>
        <div v-if="addModal" class="modal-overlay">
            <div class="modal">
                <div class="modal-content directions">
                    <div class="direction-item direction-item-modal">
                        <i class="fa-solid fa-route"></i>
                        <input type="text" v-model="newAddress.ciudad" placeholder="Ciudad" class="city">
                        <i class="fa-solid fa-house-flag"></i>
                        <div class="bottom-form">
                            <input type="text" v-model="newAddress.barrio" placeholder="Barrio">
                            <input type="text" v-model="newAddress.calle" placeholder="Calle">
                            <input type="text" v-model="newAddress.direccion" placeholder="Dirección">
                        </div>
                    </div>
                </div>
                <button @click="addNewAddress">Guardar</button>
                <button @click="showAddModal">Cancelar</button>
            </div>
        </div>
        <div v-if="editModal" class="modal-overlay">
            <div class="modal">
                <div class="modal-content directions">
                    <div class="direction-item direction-item-modal">
                        <i class="fa-solid fa-route"></i>
                        <input type="text" v-model="editingAddress.ciudad" placeholder="Ciudad" class="city">
                        <i class="fa-solid fa-house-flag"></i>
                        <div class="bottom-form">
                            <input type="text" v-model="editingAddress.barrio" placeholder="Barrio">
                            <input type="text" v-model="editingAddress.calle" placeholder="Calle">
                            <input type="text" v-model="editingAddress.direccion" placeholder="Dirección">
                        </div>
                    </div>
                </div>
                <button @click="saveEditedAddress">Guardar</button>
                <button @click="showEditModal">Cancelar</button>
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
            addModal: false,
            editModal: false,
            newAddress: {
                ciudad: '',
                barrio: '',
                calle: '',
                direccion: '',
            },
            editingIndex: -1,
            editingAddress: {
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
        showEditModal(index) {
            this.editingIndex = index;
            this.editingAddress = { ...this.directions[index] };
            this.addresModal = true;
            this.editModal = !this.editModal
        },
        showAddModal() {
            this.addModal = !this.addModal;
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
        saveEditedAddress() {
            const editedAddress = this.editingAddress;

            const dataToSend = {
                functionName: "options_modify_address",
                token: sessionStorage.getItem('miToken') || 0,
                id: this.directions[this.editingIndex].id,
                ciudad: editedAddress.ciudad,
                barrio: editedAddress.barrio,
                calle: editedAddress.calle,
                numero: editedAddress.direccion
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response.data);
                    this.directions[this.editingIndex] = { ...editedAddress };
                    this.editModal = false;
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
                    this.newAddress = {
                        ciudad: '',
                        barrio: '',
                        calle: '',
                        direccion: '',
                    }
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
  