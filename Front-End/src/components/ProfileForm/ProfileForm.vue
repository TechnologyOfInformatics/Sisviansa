<template>
    <div>
        <form class="user-form" @submit="updateUserInfo">
            <div>
                <label for="primerNombre">Primer Nombre:</label>
                <input type="text" id="primerNombre" v-model="userInfo.primerNombre" />
            </div>
            <div>
                <label for="primerApellido">Primer Apellido:</label>
                <input type="text" id="primerApellido" v-model="userInfo.primerApellido" />
            </div>
            <div>
                <label for="segundoNombre">Segundo Nombre:</label>
                <input type="text" id="segundoNombre" v-model="userInfo.segundoNombre" />
            </div>
            <div>
                <label for="segundoApellido">Segundo Apellido:</label>
                <input type="text" id="segundoApellido" v-model="userInfo.segundoApellido" />
            </div>
            <div>
                <label for="correo">Correo:</label>
                <input type="email" id="correo" v-model="userInfo.correo" />
            </div>
            <div>
                <label for="direccion">Dirección:</label>
                <input type="text" id="direccion" v-model="userInfo.direccion" />
            </div>
            <div>
                <label for="documento">Documento de Identidad:</label>
                <span id="documento">{{ userInfo.documento }}</span>
            </div>
            <div>
                <label for="tipo">Tipo de Documento:</label>
                <span id="tipo">{{ userInfo.tipoDocumento }}</span>
            </div>
            <button type="submit">Guardar Cambios</button>
        </form>
    </div>
</template>
<script>
export default {

    data() {
        return {
            userInfo: {
                primerNombre: "",
                primerApellido: "",
                segundoNombre: "",
                segundoApellido: "",
                correo: "",
                direccion: "",
                documento: "12345678",
                tipoDocumento: "Cedula",
            }, //cambiar los datos por lo que me da el backend
        };
    },
    created() {
        this.fetchUserData()
    },
    methods: {
        fetchUserData() {
            const dataToSend = {
                functionName: "options_user_info",
                token: sessionStorage.getItem('miToken') || 0,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response.data)
                    this.userInfo = response.data;

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
    max-width: 400px;
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