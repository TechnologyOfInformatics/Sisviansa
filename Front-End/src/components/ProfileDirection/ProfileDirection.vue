<template>
    <main>
        <div class="directions-container">
            <ul class="direction-list"  v-if="Array.isArray(this.directions)">
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
                <div v-if="this.directions.length === 0">
                    <div class="direction-item-null">
                        <DirectionProfileButton />
                    </div>
                    <div class="direction-item-null">
                        <DirectionProfileButton />
                    </div>
                    <div class="direction-item-null">
                        <DirectionProfileButton />
                    </div>
                </div>
                <div v-if="this.directions.length === 1">

                    <div class="direction-item-null">
                        <DirectionProfileButton />
                    </div>
                    <div class="direction-item-null">
                        <DirectionProfileButton />
                    </div>
                </div>

                <div v-if="this.directions.length === 2">
                    <div class="direction-item-null">
                        <DirectionProfileButton />
                    </div>
                </div>
            </ul>
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
  