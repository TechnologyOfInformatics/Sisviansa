<template>
  <MainHeader />
  <div class="container" :class="{ 'right-panel-active': isSignUp }" id="main">
    <LoginForm />
    <RegisterForm />
    <div class="overlay-container">
      <div class="overlay">
        <div class="overlay-left">
          <h1>Bienvenido a Sisviansa!</h1>
          <p>
            Para mantenerte conectado usa tu información personal para
            registrarte!
          </p>
          <button @click="isSignUp = false">Inicia sesión</button>
        </div>
        <div class="overlay-right">
          <h1>Hola denuevo!</h1>
          <p>Ingresa tus datos para poder iniciar sesión</p>
          <button @click="isSignUp = true">Registrate</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import MainHeader from "@/components/Header/Header.vue";
import LoginForm from "@/components/LoginForm/LoginForm.vue";
import RegisterForm from "@/components/RegisterForm/RegisterForm.vue";

export default {
  components: {
    LoginForm,
    RegisterForm,
    MainHeader,
  },
  data() {
    return {
      isSignUp: false,
    };
  },
};
</script>

<style scoped>
* {
  box-sizing: border-box;
}

body {
  align-items: center;
  display: flex;
  justify-content: center;
  flex-direction: column;
  background: #f6f5f7;
  min-height: 100%;
  margin: 10%;
}

.container {
  margin: 3em auto;
  position: relative;
  width: 57vw;
  max-width: 100%;
  min-height: 85vh;
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px rgba(0, 0, 0, 0.22);
  display: flex;
}

.sign-up,
.sign-in {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  transition: all 0.6s ease-in-out;
}

.sign-up {
  width: 50%;
  opacity: 0;
  z-index: 1;
}

.sign-in {
  width: 50%;
  z-index: 2;
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

#signIn,
#signUp {
  background-color: transparent;
  border: 2px solid #fff;
}

.container.right-panel-active .sign-in {
  transform: translateX(100%);
}

.container.right-panel-active .sign-up {
  transform: translateX(100%);
  opacity: 1;
  z-index: 5;
  animation: show 0.6s;
}

@keyframes show {
  0%,
  49.99% {
    opacity: 0;
    z-index: 1;
  }

  50%,
  100% {
    opacity: 1;
    z-index: 5;
  }
}

.overlay-container {
  position: absolute;
  top: 0;
  left: 50%;
  width: 50%;
  height: 100%;
  overflow: hidden;
  transition: transform 0.6s ease-in-out;
  z-index: 100;
}

.container.right-panel-active .overlay-container {
  transform: translateX(-100%);
}

.overlay {
  position: relative;
  color: white;
  background: rgba(61, 166, 241, 0.8);
  left: -100%;
  height: 100%;
  width: 200%;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1440 320'%3E%3Cpath fill='%23a2d9ff' fill-opacity='10' d='M0,64L34.3,69.3C68.6,75,137,85,206,80C274.3,75,343,53,411,42.7C480,32,549,32,617,69.3C685.7,107,754,181,823,186.7C891.4,192,960,128,1029,122.7C1097.1,117,1166,171,1234,181.3C1302.9,192,1371,160,1406,144L1440,128L1440,0L1405.7,0C1371.4,0,1303,0,1234,0C1165.7,0,1097,0,1029,0C960,0,891,0,823,0C754.3,0,686,0,617,0C548.6,0,480,0,411,0C342.9,0,274,0,206,0C137.1,0,69,0,34,0L0,0Z'%3E%3C/path%3E%3C/svg%3E");
  transform: translateX(0);
  background-size: cover;
  background-position: left center;
  background-repeat: no-repeat;

  transition: transform 0.6s ease-in-out;
}
.overlay button {
  font-family: monospace;
  font-size: 1em;
}

.container.right-panel-active .overlay {
  transform: translateX(50%);
}

.overlay-left,
.overlay-right {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  padding: 0 40px;
  text-align: center;
  top: 0;
  height: 100%;
  width: 50%;
  transform: translateX(0);
  transition: transform 0.6s ease-in-out;
}

.overlay-left {
  transform: translateX(-20%);
}

.overlay-right {
  right: 0;
  transform: translateX(0);
}

.container.right-panel-active .overlay-left {
  transform: translateX(0);
}

.container.right-panel-active .overlay-right {
  transform: translateX(20%);
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
  .container {
    width: 90vw;
    display: flex;
    flex-direction: column;
    background-color: red;
    flex-wrap: nowrap;
  }

  /* hacer responsive */
}
</style>
