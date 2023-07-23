<template>
  <div class="sign-up">
    <form>
      <h1>Crear cuenta</h1>

      <p> Agrega tus datos para registrarte</p>
      <input type="text" name="txt" placeholder="Nombre" required />
      <input type="text" name="txt" placeholder="Cedula Uruguaya" required />
      <input type="email" name="email" placeholder="Correo electronico" required />
      <input type="password" name="pswd" placeholder="Contraseña" required />
      <input type="password" name="cmpswd" placeholder="Confirma la contraseña" required />

      <button>Registrate</button>
    </form>
  </div>
</template>

<script>
export default {
  name: "RegisterForm",
};
</script>

<style scoped>
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
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  padding: 0 50px;
  height: 100%;
  text-align: center;
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
  background: #eee;
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
  border: 1px solid #a2d9ff;
  color: white;
  background: #a2d9ff;
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
</style>
