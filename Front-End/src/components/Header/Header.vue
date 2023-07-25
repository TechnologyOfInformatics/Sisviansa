<template>
  <header>
    <nav>
      <div class="nav__top" v-if="showTop">
        <div>
          <p v-if="isAuthenticated" class="nav__welcome">Bienvenido {{ user }}</p>
          <router-link v-else to="/login" class="link">
            <p class="nav__welcome">Bienvenido (Inicia sesión)</p>
          </router-link>
        </div>
        <div class="nav__logo">
          <img src="@/assets/icons/logotipo.png" alt="Logotipo ilustrativo de la empresa" />
          <p>Sisviansa</p>
        </div>
        <router-link v-if="isAuthenticated" to="/" class="link">
          <div class="action__button" @click="logout">
            <i class="fa-solid fa-right-to-bracket"></i>
          </div>
        </router-link>
        <router-link v-else to="/login" class="link">
          <div class="action__button">
            <i class="fa-solid fa-right-from-bracket"></i>
          </div>
        </router-link>
      </div>
      <hr />
      <div class="nav__bottom">
        <div class="nav__bottom__address" v-if="showAddresses">
          <img src="@/assets/page-icons/truck.png" alt="Camion de direccion" />
        </div>

        <ul class="nav__menu" :class="{ open: menuOpen }" id="navMenu">
          <li :class="{ selected: $route.path === '/' }">
            <router-link to="/" class="link">Inicio</router-link>
          </li>
          <li :class="{ selected: $route.path === '/shop' }">
            <router-link to="/shop" class="link">Tienda</router-link>
          </li>
          <li :class="{ selected: $route.path === '/faq' }">
            <router-link to="/faq" class="link">Preguntas Frecuentes</router-link>
          </li>
        </ul>
        <div class="nav__bottom__cart" v-if="showCart">
          <img src="@/assets/page-icons/cart.png" alt="Carrito de compra" @click="handleCartClicked" />

          <span class="cart-count" v-if="cart.length > 0">
            {{ cart.length }}
          </span>
        </div>
        <div class="nav__hamburger" @click="toggleMenu">
          <i v-if="menuOpen" class="fa-solid fa-bars-staggered"></i>
          <i v-else class="fa-solid fa-bars"></i>
        </div>
      </div>
    </nav>
  </header>
</template>

<script>
export default {
  name: "MainHeader",

  props: {
    cart: {
      type: Array,
      default: () => [],
    },
  },
  data() {
    return {
      showAddresses: false,
      showTop: true,
      showCart: false,
      menuOpen: false,
      user: "",
      isAuthenticated: false,
    };
  },
  created() {
    this.fetchUserData();
    this.checkRoutePath();
  },
  watch: {
    $route: "checkRoutePath",
  },
  methods: {
    fetchUserData() {
      const dataToSend = {
        functionName: "base_session",
        token: sessionStorage.getItem('miToken'),
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          const userData = response.data;
          this.user = userData[1] + " " + userData[2];
          this.isAuthenticated = userData[0];
        })
        .catch((error) => {
          console.error(error);
        });
    },
    toggleMenu() {
      this.menuOpen = !this.menuOpen;
    },
    checkRoutePath() {
      if (this.$route.path === "/shop") {
        this.showAddresses = true;
        this.showCart = true;
      }
      if (this.$route.path === "/login") {
        this.showTop = false;
      }
    },
    handleCartClicked() {
      this.$emit("cart-clicked");
    },
    logout() {
      sessionStorage.removeItem('miToken');
      this.isAuthenticated = false;
      this.$router.push("/");
    },
  },
};
</script>

<style lang="css" src="./Header.css"></style>
