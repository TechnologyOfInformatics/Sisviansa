<template>
  <div class="sign-up" v-if="web">
    <form @submit.prevent="registerWeb">

      <h1>Crear cuenta de Usuario</h1>
      <input v-model="name" type="text" name="txt" placeholder="Nombre" required autocomplete="name" id="first_name" />
      <input v-model="surname" type="text" name="txt" placeholder="Apellido" required autocomplete="name"
        id="first_surname" />
      <input v-model="doc" type="text" name="txt" placeholder="Cedula" required id="doc" />
      <input v-model="doc_type" type="text" name="txt" placeholder="Tipo de cedula" required id="doc_type" />
      <input v-model="mail" type="email" name="email" placeholder="Correo electrónico" required autocomplete="email"
        id="mail" />
      <input v-model="passwd" type="password" name="pswd" placeholder="Contraseña" required autocomplete="new-password"
        id="passwd" />
      <input v-model="confirmPasswd" type="password" name="cmpswd" placeholder="Confirma la contraseña" required
        autocomplete="new-password" id="cmfpasswd" />
      <div v-if="errorMessage" class="error-message">
        {{ errorMessage }}
      </div>
      <div v-if="succesMessage" class="succes-message">
        {{ succesMessage }}
      </div>
      <button type="submit">Registrate</button>
    </form>
  </div>
</template>
<script>

export default {
  data() {
    return {
      name: "",
      surname: "",
      doc: "",
      doc_type: "",
      mail: "",
      passwd: "",
      confirmPasswd: "",

      nameb: '',
      rut: '',
      mailb: "",
      passwdb: "",
      confirmPasswdb: "",

      web: true,

      errorMessage: "",
      succesMessage: "",
    };
  },

  methods: {

    toggleOption() {

      this.web = !this.web
    },
    registerWeb() {
      if (this.passwd !== this.confirmPasswd) {
        this.errorMessage = 'Error, las contrase;as no coinciden.'
        return;
      }

      const dataToSend = {
        functionName: "register_register_web_first",
        name: this.name,
        surname: this.surname,
        doc_type: this.doc_type,
        doc: this.doc,
        mail: this.mail,
        passwd: this.passwd,
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data);
          if (response.data == '403, FORBIDDEN: You are not allowed to enter the system') {
            this.succesMessage = 'Se ha registrado, aguarde a ser autorizado.'
          } else if (typeof (response.data) == 'string') {
            this.errorMessage = 'Error, intente nuevamente.'
          } else {
            let token = response.data[1];
            if (token) {
              sessionStorage.setItem('miToken', token);
              window.history.back();
            }
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    registerBussines() {
      if (this.passwd !== this.confirmPasswd) {
        this.errorMessage = 'Error, las contrase;as no coinciden.'
        return;
      }

      const dataToSend = {
        functionName: "register_register_bussines_first",
        name: this.nameb,
        doc: this.rut,
        mail: this.mail,
        passwd: this.passwd,
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data);
          if (Array.isArray(response.data)) {
            let token = response.data[1];
            if (token) {
              sessionStorage.setItem('miToken', token);
              window.history.back();
            }
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
  },
};
</script>

<style scoped>
.error-message {
  color: red;
}

.sign-up {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  transition: all 0.6s ease-in-out;
  width: 50%;
  opacity: 0;
  z-index: 1;
}

form {
  background: #ebeadf;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  padding: 20px 50px;
  height: 100%;
  text-align: center;
  border-left: 1px solid #243328;
}

h1 {
  font-weight: bold;
  margin: 0;
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

button[type='submit'] {
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

button[type='submit']:active {
  transform: scale(0.9);
}

button[type='submit']:hover {
  background: #304035;
}

.toggle-btn {
  width: 20vw;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  background-color: transparent;
  position: absolute;
  transform: translate(.5vw, .2vh);
}

.toggle-btn label {
  width: 95%;

}

.toggle-btn input {
  width: 5%;
  color: red;
  transform: translateX(-4vw);
}

#signUp {
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

@media (max-width: 768px) {
  input {
    width: 190%;
    padding: 12px 8px;

  }

  a {
    font-size: 15px;
  }

  button {
    padding: 12px 25px;
  }
}
</style>
