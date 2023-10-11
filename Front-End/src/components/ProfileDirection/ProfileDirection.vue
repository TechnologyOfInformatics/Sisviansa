<template>
    <main>
        <div v-if="this.directions.length === 0" class="empty-direction-message directions-container">
            <span>Usted no tiene direcciones</span> <br>
            <span>Puedes añadir una en </span><router-link to="/profile" class="link">tú perfil</router-link>

        </div>
        <div v-else>
            <div class="directions-container">
                <ul class="direction-list">
                    <li v-for="(direction, index) in directions" :key="index" class="direction-list-item">
                        <div>
                            <div>
                                <p class="direction-quantity">Dirección</p>
                                <p class="direction-quantity-index">: {{ index }}</p>
                            </div>
                            <div class="direction-item">
                                <p class="direction-item-city">{{ direction.ciudad }}</p>
                                <div>
                                    <p> {{ direction.barrio }}, {{ direction.calle }} {{direction.direccion}}</p>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>

            </div>
        </div>
    </main>
</template>
  
<script>
export default {
    name: "ProfileDirection",

    data() {
        return {
            directions: [],
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

    },
    mounted() {
        window.addEventListener("scroll", this.handleScroll);
    },
};
</script>
  
  
<style lang="css" src="./ProfileDirection.css" scoped></style>
  