

<template>
    <div class="container" id="main">

        <div class="sign-in">
            <form @submit.prevent="login">
                <h1>Inicia sesión</h1>
                <p>Coloca los datos de tu cuenta</p>
                <input v-model="ci" type="text" name="mail" placeholder="Cedula" required autocomplete="ci" id="ci" />
                <input v-model="password" type="password" name="pswd" placeholder="Password" required
                    autocomplete="current-password" id="password" @input="clearErrorMessage" />
                <button type="submit">Inicia Sesión</button>
                <div v-if="errorMessage" class="error-message">
                    {{ errorMessage }}
                </div>
                
            </form>
        </div>
        <div class="container-img">
            <img src="../../assets/icons/logotipo.png" alt="">
        ads
        </div>
    </div>
</template >

<script>
export default {

    data() {
        return {
            mail: "",
            password: "",
            errorMessage: "",

        };
    },

    methods: {
        login() {


            const attemptLogin = () => {
                let dataToSend = {
                    functionName: "",
                    mail: this.mail,
                    passwd: this.password,
                };

                this.$http
                    .post("http://localhost/Back-End/server.php", dataToSend)
                    .then((response) => {
                        console.log(response)



                    })
                    .catch((error) => {
                        console.log(error)
                        this.errorMessage = "Error al conectar con el servidor.";
                    });
            };

            attemptLogin();
        },
        clearErrorMessage() {
            if (this.password.length >= 4) {
                this.errorMessage = "";
            }

        },

    },

};
</script>
  
<style scoped>
.error-message {
    color: red;
}

.sign-in {
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    transition: all 0.6s ease-in-out;
    width: 50%;
    z-index: 2;
}

form {
    background: #ebeadf;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    padding: 0 50px;
    height: 100%;
    text-align: center;
    border-right: 1px solid #243328;

}

h1 {
    font-weight: bold;
    margin: 0;
}

main {
    margin: 2.5em 0;
}

.container {
    font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif ;
    margin: 3em auto;
    position: relative;
    width: 57vw;
    max-width: 100%;
    min-height: 85vh;
    border-radius: 10px;
    overflow: hidden;
    background-color: #ebeadf;
    box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px rgba(0, 0, 0, 0.22);
    display: flex;
}

.container-img{
    width: 50%;
    margin-left: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
}


p {
    font-size: 14px;
    font-weight: 100;
    line-height: 20px;
    letter-spacing: 0.5px;
    margin: 15px 0 20px;
}

p {
    font-size: 14px;
    font-weight: 100;
    line-height: 20px;
    letter-spacing: 0.5px;
    margin: 15px 0 20px;
}

input {
    background: white;
    padding: 12px 15px;
    margin: 8px 15px;
    width: 100%;
    border-radius: 5px;
    border: none;
    outline: none;
}

a {
    color: #333;
    font-size: 14px;
    text-decoration: none;
    margin: 15px 0;
}

button {
    border: 1px solid #ebeadf;
    color: white;
    background: #243328;
    font-size: 12px;
    font-weight: bold;
    padding: 12px 55px;
    margin: 20px;
    border-radius: 20px;
    outline: none;
    letter-spacing: 1px;
    text-transform: uppercase;
    transition: transform 80ms ease-in;
    cursor: pointer;
}

button:active {
    transform: scale(0.9);
}

#signIn {
    background-color: transparent;
    border: 2px solid #fff;
}

.social-container {
    margin: 20px 0;
}

.social-container a {
    height: 40px;
    width: 40px;
    margin: 0 5px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
    border: 1px solid #ccc;
    border-radius: 50%;
}
</style>
  