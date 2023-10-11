<template>
    <div>
        <form class="user-form" @submit.prevent="updateUserInfo">
            <div>
                <label for="first_name">Primer Nombre:</label>
                <input type="text" id="first_name" v-model="first_name" />
            </div>

            <div>
                <label for="second_name">Segundo Nombre:</label>
                <input type="text" id="second_name" v-model="second_name" />
            </div>
            <div>
                <label for="first_surname">Primer Apellido:</label>
                <input type="text" id="first_surname" v-model="first_surname" />
            </div>
            <div>
                <label for="second_surname">Segundo Apellido:</label>
                <input type="text" id="second_surname" v-model="second_surname" />
            </div>
            <div>
                <label for="mail">Correo:</label>
                <input type="mail" id="mail" v-model="mail" />
            </div>

            <div>
                <span>Documento de Identidad:</span>
                <span id="id">{{ id }}</span>
            </div>
            <div>
                <span>Tipo de Documento:</span>
                <span id="tipo">{{ idtype }}</span>
            </div>
            <button type="submit">Guardar Cambios</button>
        </form>
    </div>
</template>
<script>
export default {

    data() {
        return {
            first_name: "",
            second_name: "",
            first_surname: "",
            second_surname: "",
            mail: "",
            id: "",
            idtype: "",
        };
    },
    created() {
        this.fetchUserData()
    },
    methods: {
        updateUserInfo() {
            const dataToSend = {
                functionName: "options_modify_web",
                token: sessionStorage.getItem('miToken') || 0,
                password: '',
                confirm_passwd: '',
                first_name: this.first_name,
                second_name: this.second_name,
                first_surname: this.first_surname,
                second_surname: this.second_surname,
                mail: this.mail,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response)

                })
                .catch((error) => {
                    console.error(error);
                });
        },
        fetchUserData() {
            const dataToSend = {
                functionName: "options_user_info",
                token: sessionStorage.getItem('miToken') || 0,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response);
                    this.first_name = response.data.primerNombre;
                    this.second_name = response.data.segundoNombre;
                    this.first_surname = response.data.primerApellido;
                    this.second_surname = response.data.segundoApellido;
                    this.mail = response.data.correo;
                    this.id = response.data.documento;
                    this.idtype = response.data.tipoDocumento;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
    },

};
</script>
  
<style scoped>
.user-form {
    margin: 0 auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
}

.user-form div {
    margin-bottom: 10px;
}

.user-form label {
    font-weight: bold;
}

.user-form input[type="text"],
.user-form input[type="email"],
.user-form button {
    width: 100%;
    padding: 10px;
    margin-top: 5px;
    border: 1px solid #ccc;
    border-radius: 3px;
}

.user-form span {
    display: inline-block;
    padding: 10px;
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    border-radius: 3px;
}

.user-form button {
    background-color: #007bff;
    color: #fff;
    cursor: pointer;
}

.user-form button:hover {
    background-color: #0056b3;
}
</style>