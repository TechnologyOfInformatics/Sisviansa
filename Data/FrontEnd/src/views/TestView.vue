<template>
    <form @submit.prevent="fetchUserData">
        <label for="data">Datos </label>
        <input type="text" name="data" class="input" placeholder="Type your text" id="data" v-model="data">
        <br>
        <label for="functions">Funcion </label>
        <input type="text" name="functions" class="input" placeholder="Type your text" id="functions" v-model="functions">
        <label for="functions">Host </label>
        <input type="text" name="host" class="input" placeholder="Type your text" id="host" v-model="host">
        <button type="submit">Enviar</button>
    </form>
</template>

<script>

export default {
    data() {
        return {
            data: '',
            functions: '',
            host: '',
        };
    },

    methods: {
        fetchUserData() {
            const dataToSend = {
                data: this.data,
                functions: this.functions
            };

            this.$http
                .post(this.host, dataToSend)
                .then((response) => {
                    console.log(response.data);
                })
                .catch((error) => {
                    console.error(error);
                });
        },
    }
}
</script>

<style>
</style>