<template>
  <MainHeader />
  <div class="profile-container">
    <aside class="profile-sidebar">
      <nav class="profile-sidebar__nav">
        <ul>
          <li @click="selectOption('Account')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'Account' }">
            <span v-if="isDesktop">Datos de tu cuenta</span>
            <i class="fa-solid fa-user" v-else></i>
          </li>
          <li @click="selectOption('Security')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'Security' }">
            <span v-if="isDesktop">Seguridad</span>
            <i class="fas fa-shield-alt" v-else></i>
          </li>
          <li @click="selectOption('OrderHistory')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'OrderHistory' }">
            <span v-if="isDesktop"> Historial de Pedidos</span>
            <i class="fa-solid fa-timeline" v-else></i>
          </li>
          <li @click="selectOption('ShippingAddress')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'ShippingAddress' }">
            <span v-if="isDesktop">Direcciones de envío</span>
            <i class="fa-solid fa-truck-fast" v-else></i>
          </li>

          <li @click="selectOption('Favorites')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'Favorites' }">
            <span v-if="isDesktop">Menus Favoritos</span>
            <i class="fa-solid fa-heart" v-else></i>
          </li>

        </ul>
      </nav>
    </aside>
    <main class="profile-main">
      <div v-if="selectedOption === 'Account'">
        <ProfileForm :web=this.web />
      </div>
      <div v-if="selectedOption === 'Security'">
        <SecurityForm />
      </div>
      <div v-if="selectedOption === 'OrderHistory'">
        <OrderHistory />
      </div>
      <div v-if="selectedOption === 'ShippingAddress'">
        <ProfileDirection />
      </div>
      <div v-if="selectedOption === 'Favorites'">
        <MenuCard :custom="true"/>
      </div>
    </main>
  </div>
</template>

<script>
import MainHeader from "@/components/Header/Header.vue";
import ProfileForm from "@/components/ProfileForm/ProfileForm.vue";
import ProfileDirection from '@/components/ProfileDirection/ProfileDirection.vue'
import SecurityForm from "@/components/SecurityForm/SecurityForm.vue";
import OrderHistory from '@/components/OrderHistory/OrderHistory.vue';
import MenuCard from '@/components/MenuCard/MenuCard.vue';



export default {
  components: {
    MainHeader,
    ProfileForm,
    ProfileDirection,
    SecurityForm,
    OrderHistory,
    MenuCard
  },
  data() {
    return {
      selectedOption: "Account",
      login: true,
      web: true,
      isDesktop: window.innerWidth >= 1024
    };
  },
  methods: {
    selectOption(option) {
      this.selectedOption = option;
    },
    validateUserData() {
      const token = sessionStorage.getItem("miToken") || "undefined";
      const dataToSend = {
        functionName: "base_session",
        token: token,
      };

      return this.$http.post("http://localhost/Back-End/server.php", dataToSend);
    },
    handleRouteLogic() {

      this.validateUserData()
        .then((response) => {

          if (this.login) {
            if (Array.isArray(response.data)) {
              if (response.data[0] == false) {
                this.$router.push("/profile");
              } else if (response.data[0] === true) {
                this.$router.push("/bussines");

              }
            } else {
              this.$router.push("/login");
            }
          }
        })
        .catch((error) => {
          console.error(error);

        });
    },
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.handleRouteLogic();
    });
  },
};
</script>
<style scoped>
.profile-container {
  max-width: 100vw;
  max-height: 83.8vh;
  display: flex;
}

.profile-sidebar {
  width: 20vw;
  height: 83.9vh;
  background-color: #243328;
  color: #fff;
  display: flex;
  flex-direction: column;
  position: fixed;
}

.profile-sidebar__nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.profile-sidebar__nav ul li {
  padding: 1em;
  cursor: pointer;
  transition: background-color 0.3s;

}

.profile-sidebar__nav ul li:hover {
  background-color: #ebeadf;
  color: black;
}

.profile-sidebar__nav-item--active {
  background-color: #ebeadf;
  font-weight: bold;
  color: black;
}

.profile-main {
  height: 78.2vh;
  width: 80vw;
  margin-left: 20vw;
  background-color: #ebeadf;
  flex: 1;
  padding: 20px;
}

.profile-main h2 {
  font-size: 24px;
  margin-bottom: 10px;
  color: #333;
}
</style>
