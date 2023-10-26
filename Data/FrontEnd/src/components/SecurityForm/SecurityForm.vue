<template>
  <div class="form-container">
    <form class="user-form" @submit.prevent="updateUserInfo">
      <h1>Cambia tu contraseña</h1>
      <div>
        <label for="current_password">Contraseña Actual:</label>
        <input
          type="password"
          id="current_password"
          v-model="current_password"
        />
      </div>

      <div>
        <label for="new_password">Nueva Contraseña:</label>
        <input
          type="password"
          id="new_password"
          v-model="new_password"
          @input="validatePassword"
        />
      </div>

      <div>
        <label for="confirm_password">Confirmar Nueva Contraseña:</label>
        <input
          type="password"
          id="confirm_password"
          v-model="confirm_password"
          @input="validatePassword"
        />
      </div>

      <div class="button-form">
        <button type="submit">Guardar Cambios</button>
      </div>
    </form>
    <div class="user-form">
      <h2>Requisitos:</h2>
      <div class="form-password-data">
        <p id="error-length" class="error-message">
          Tu contraseña debe tener más de 8 caracteres
        </p>
        <p id="error-number" class="error-message">
          Tu contraseña debe tener al menos un número
        </p>
        <p id="error-letter" class="error-message">
          Tu contraseña debe tener al menos una letra
        </p>
        <p id="error-name" class="error-message">
          Tu contraseña no debe contener tu nombre
        </p>
        <p id="error-match" class="error-message">
          Las contraseñas deben coincidir
        </p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      current_password: "",
      new_password: "",
      confirm_password: "",
      name: "",
      errors: {
        length: false,
        number: false,
        letter: false,
        name: false,
        match: false,
      },
    };
  },
  created() {
    this.fetchUserData();
  },
  methods: {
    validatePassword() {
      this.errors = {
        length: this.new_password.length < 8,
        number: !/\d/.test(this.new_password),
        letter: !/[a-zA-Z]/.test(this.new_password),
        name: this.new_password.includes(this.name),
        match: this.new_password !== this.confirm_password,
      };

      Object.keys(this.errors).forEach((errorKey) => {
        const errorMessage = document.getElementById(`error-${errorKey}`);
        if (this.errors[errorKey]) {
          errorMessage.classList.add("active");
        } else {
          errorMessage.classList.remove("active");
        }
      });
    },
    updateUserInfo() {
      this.errors = {
        length: this.new_password.length < 8,
        number: !/\d/.test(this.new_password),
        letter: !/[a-zA-Z]/.test(this.new_password),
        name: this.new_password.includes(this.name),
        match: this.new_password !== this.confirm_password,
      };
      Object.keys(this.errors).forEach((errorKey) => {
        const errorMessage = document.getElementById(`error-${errorKey}`);
        if (this.errors[errorKey]) {
          errorMessage.classList.add("active");
        } else {
          errorMessage.classList.remove("active");
        }
      });

      if (Object.values(this.errors).some((error) => error)) {
        console.log("Cancelando conexion con backend");
        return;
      }
      const dataToSend = {
        functionName: "options_change_password",
        token: sessionStorage.getItem("miToken") || 0,
        current_password: this.current_password,
        password: this.new_password,
        confirm_passwd: this.confirm_password,
      };

      this.$http
        .post("http://sisviansa_php/server.php", dataToSend)
        .then((response) => {
          console.log(response);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    fetchUserData() {
      const dataToSend = {
        functionName: "base_session",
        token: sessionStorage.getItem("miToken") | 0,
      };
      this.$http
        .post("http://sisviansa_php/server.php", dataToSend)
        .then((response) => {
          const userData = response.data;
          this.name = userData[1];
        })
        .catch((error) => {
          console.error(error);
        });
    },
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
  justify-content: space-between;
  align-items: center;
  height: 71.4vh;
}

.user-form {
  height: 60vh;
  width: 29vw;
  margin: 0 auto;
  background-color: #243328;
  padding: 2em 3em;
  border-radius: 5px;
  border: 1px solid white;
}

.user-form div {
  margin-bottom: 10px;
}

.error-message {
  color: #ccc;
  margin-top: 10px;
}

.error-message.active {
  color: red;
}

.user-form label {
  font-weight: bold;
}

.user-form input[type="password"],
.user-form button {
  width: 27vw;
  padding: 10px;
  margin-top: 15px;
  border: 1px solid #ccc;
  border-radius: 3px;
  margin: 0 auto;
}

.user-form button {
  width: 26vw;
  text-align: center;
  margin: 0 auto;
  align-self: center;
}

.user-form .button-form {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 28vw;
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
