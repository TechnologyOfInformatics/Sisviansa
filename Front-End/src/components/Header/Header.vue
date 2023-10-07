<template>
  <header>
    <nav>
      <div class="nav__top" v-if="showTop">
        <div>
          <p v-if="isAuthenticated" class="nav__welcome">Bienvenido {{ user }}</p>
          <router-link v-else to="/login" class="link nav__welcome">
            <p>Bienvenido (<span>Inicia sesión</span>) </p>
          </router-link>
        </div>
        <div class="nav__logo">
          <img src="@/assets/icons/logotipo-header.png" alt="Logotipo ilustrativo de la empresa" />
          <p>Sisviansa</p>
        </div>
        <router-link v-if="isAuthenticated" to="/" class="link">
          <div class="action__button" @click="logout">
            <i class="fa-solid fa-right-from-bracket"></i>
          </div>
        </router-link>
        <router-link v-else to="/login" class="link">
          <div class="action__button">
            <i class="fa-solid fa-right-to-bracket"></i>
          </div>
        </router-link>
      </div>
      <hr />
      <div class="nav__bottom">
        <div class="nav__bottom__address" v-if="showAddresses">
          <i class="fa-solid fa-truck-fast" @click="toggleDirectionModal"></i>
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
          <li :class="{ selected: $route.path === '/profile' }">
            <router-link to="/profile" class="link">Perfil</router-link>
          </li>
        </ul>
        <div class="nav__bottom__cart" v-if="showCart">
          <i class="fa-solid fa-cart-shopping" @click="toggleCartModal"></i>
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
      const token = sessionStorage.getItem('miToken');


      if (token) {
        const dataToSend = {
          functionName: "base_session",
          token: token,
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
      }
    }, toggleMenu() {
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
    toggleCartModal() {
      this.$emit("toggle-cart-modal");
    },
    toggleDirectionModal() {
      this.$emit("toggle-direction-modal");
    },

    logout() {
      sessionStorage.removeItem('miToken');
      this.isAuthenticated = false;
      this.$router.push("/");
    },
  },
};
</script>

<style lang="css" src="./Header.css" scoped></style>
