<template>
  <MainHeader />
  <div class="profile-container">
    <aside class="profile-sidebar">
      <nav class="profile-sidebar__nav">
        <ul>
          <li @click="selectOption('Personalization')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'Personalization' }">Personalización</li>
          <li @click="selectOption('Account')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'Account' }">Datos de tu cuenta</li>
          <li @click="selectOption('Security')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'Security' }">Seguridad</li>
          <li @click="selectOption('OrderHistory')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'OrderHistory' }">Historial de Pedidos</li>
          <li @click="selectOption('ShippingAddress')"
            :class="{ 'profile-sidebar__nav-item--active': selectedOption === 'ShippingAddress' }">Direcciones de envío
          </li>
        </ul>
      </nav>
    </aside>
    <main class="profile-main">
      <div v-if="selectedOption === 'Personalization'">
      </div>
      <div v-if="selectedOption === 'Account'">
        <ProfileForm />
      </div>
      <div v-if="selectedOption === 'Security'">
      </div>
      <div v-if="selectedOption === 'OrderHistory'">
        <h2>Order History</h2>
      </div>
      <div v-if="selectedOption === 'ShippingAddress'">
        <h2>Shipping Address</h2>
      </div>
    </main>
  </div>
</template>

<script>
import MainHeader from "@/components/Header/Header.vue";
import ProfileForm from "@/components/ProfileForm/ProfileForm.vue";

export default {
  components: {
    MainHeader,
    ProfileForm
  },
  data() {
    return {
      selectedOption: "Personalization",
      login: true,
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
            if (response.data[0] !== true) {
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
  display: flex;
  height: 100%;
}

.profile-sidebar {
  width: 20vw;
  background-color: #243328;
  color: #fff;
  display: flex;
  flex-direction: column;
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
}

.profile-sidebar__nav-item--active {
  background-color: #ebeadf;
  font-weight: bold;
  color: black;
}

.profile-main {

  flex: 1;
  padding: 20px;
}

.profile-main h2 {
  font-size: 24px;
  margin-bottom: 10px;
  color: #333;
}
</style>
