<template>
    <div class="form-container" v-if="web">
        <form class="user-form" @submit.prevent="updateUserInfo">
            <div>
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
            </div>
            <div class="user-form-id">
                <div>
                    <span class="id-span">Documento de Identidad: <span id="id">{{ id }}</span></span>

                </div>
                <div>
                    <span class="id-span">Tipo de Documento: <span id="tipo">{{ idtype }}</span></span>

                </div>
            </div>
            <div class="button-form">
                <button type="submit">Guardar Cambios</button>
            </div>
        </form>
    </div>
    <div class="form-container" v-else>
        <form class="user-form" @submit.prevent="updateUserInfo">
            <div>
                <div>
                    <label for="name">Nombre de empresa:</label>
                    <input type="text" id="name" v-model="name" />
                </div>
                <div>
                    <label for="mailb">Correo:</label>
                    <input type="mailb" id="mailb" v-model="mailb" />
                </div>
            </div>
            <div class="user-form-id">
                <div>
                    <span class="id-span">Rut: <span id="tipo">{{ rut }}</span></span>

                </div>
            </div>

        </form>
    </div>
</template>
<script>
export default {
    props: {
        web: Boolean,
    },
    data() {

        return {
            first_name: "",
            second_name: "",
            first_surname: "",
            second_surname: "",
            mail: "",
            id: "",
            idtype: "",

            name: '',
            mailb: '',
            rut: ''
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
            if (this.web) {
                const dataToSend = {
                    functionName: "options_user_info",
                    token: sessionStorage.getItem('miToken') || 0,
                };

                this.$http
                    .post("http://localhost/Back-End/server.php", dataToSend)
                    .then((response) => {
                        console.log(response.data);
                        this.first_name = response.data.primerNombre
                        this.second_name = response.data.segundoNombre
                        this.first_surname = response.data.primerApellido
                        this.second_surname = response.data.segundoApellido
                        this.mail = response.data.correo
                        this.id = response.data.documento
                        this.idtype = response.data.tipoDocumento

                    })
                    .catch((error) => {
                        console.error(error);
                    });
            }
            else {
                const dataToSend = {
                    functionName: "options_bussines_info",
                    token: sessionStorage.getItem('miToken') || 0,
                };

                this.$http
                    .post("http://localhost/Back-End/server.php", dataToSend)
                    .then((response) => {
                        console.log(response.data);
                        this.name = response.data.nombre;
                        this.rut = response.data.rut;
                        this.mailb = response.data.correo;
                        
                    })
                    .catch((error) => {
                        console.error(error);
                    });
            }
        }
    },

};
</script>
  
<style scoped>
.form-container {
    background-color: #243328;
    padding: 1.45em;
    border-radius: 15px;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;

}

.user-form {
    width: 62.5vw;
    margin: 0 auto;
    background-color: #243328;
    padding: 2em 3em;
    border-radius: 5px;
    border: 1px solid white;


}

.user-form div {
    margin-bottom: 10px;

}

.user-form-id {
    display: flex;
    flex-direction: row;
    display: flex;
    justify-content: space-around;
    align-items: center;
    width: 40vw;
    margin: 0 auto;

}

.user-form label {
    font-weight: bold;
}

.user-form input[type="text"],
.user-form input[type="mail"],
.user-form button {
    width: 61vw;
    padding: 10px;
    margin-top: 5px;
    border: 1px solid #ccc;
    border-radius: 3px;
    margin: 0 auto;
}

.user-form button {
    width: 50vw;
    text-align: center;
    margin: 0 auto;
    align-self: center;

}

.user-form .id-span {
    display: inline-block;
    padding: 10px;
    background-color: #243328;
    border: 1px solid #ddd;
    border-radius: 3px;
}

.user-form .button-form {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 62.5vw;

}

.user-form button {
    background-color: #ebeadf;
    color: black;

    cursor: pointer;
}

.user-form button:hover {
    background-color: #243328;
    color: #fff;
}
</style>