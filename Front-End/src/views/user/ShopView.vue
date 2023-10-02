<template>
  <div class="container">
    <MainAnnouncement />
    <MainHeader :cart="cart" @toggle-cart-modal="toggleCartModal" @toggle-direction-modal="toggleDirectionModal" />
    <DirectionModal :isDirectionModalVisible="isDirectionModalVisible" />
    <CartModal :cart="cart" :isCartModalVisible="isCartModalVisible" @remove-from-cart="removeFromCart"
      @update-cart="updateCart" />

    <div class="menu-filter">
      Ordenar
      <select v-model="selectedCategory">
        <option value="Mayor Calorías">Mayor Calorías</option>
        <option value="Menor Calorías">Menor Calorías</option>
        <option value="Mayor Precio">Mayor Precio</option>
        <option value="Menor Precio">Menor Precio</option>
      </select>
    </div>

    <div class="menu-filter">
      Filtrar por dieta
      <select v-model="selectedMenuType">
        <option value="Todos">Todos</option>
        <option value="Vegetariano">Vegetariano</option>
        <option value="Vegano">Vegano</option>
        <option value="Sin Gluten">Sin Gluten</option>
      </select>
    </div>
    <MenuCard @update-cart="updateCart" :filter-type="selectedMenuType" :menu-items="sortedAndFilteredMenus" />
    <ScrollButton />

    <MainFooter />
  </div>
</template>

<script>
import MainAnnouncement from "@/components/Announcement/Announcement.vue";
import MainHeader from "@/components/Header/Header.vue";
import MainFooter from "@/components/Footer/Footer.vue"
import MenuCard from "@/components/MenuCard/MenuCard.vue";
import ScrollButton from "@/components/ScrollButton/ScrollButton.vue";
import CartModal from "@/components/CartModal/CartModal.vue";
import DirectionModal from "@/components/DirectionModal/DirectionModal.vue";


export default {
  name: "ShopView",
  components: {
    MainAnnouncement,
    MainHeader,
    MenuCard,
    MainFooter,
    ScrollButton,
    CartModal,
    DirectionModal,
  },
  data() {
    return {
      cart: [],
      isCartModalVisible: false,
      selectedMenu: null,
      isDirectionModalVisible: false,
      selectedMenuType: null,
      selectedCategory: "Dieta",
      sortOrder: "asc",
      menuTypes: ["Todos", "Vegetariano", "Vegano", "Sin Gluten"],
    };
  },
  created() {
    const cartString = sessionStorage.getItem("cart");

    if (cartString) {
      this.cart = JSON.parse(cartString);
    }
  },
  methods: {
    toggleSortOrder() {
      this.sortOrder = this.sortOrder === "asc" ? "desc" : "asc";
    },
    selectMenuType(type) {
      this.selectedMenuType = type;
    },
    removeFromCart(item) {
      const index = this.cart.findIndex((cartItem) => cartItem.title === item.title);
      if (index !== -1) {
        this.cart.splice(index, 1);
        this.updateCart(this.cart);
      }
    },
    updateCart(updatedCart) {
      this.cart = updatedCart;
      const cartString = JSON.stringify(updatedCart);
      sessionStorage.setItem("cart", cartString);
    },

    toggleCartModal() {
      this.isCartModalVisible = !this.isCartModalVisible;
    },
    toggleDirectionModal() {
      this.isDirectionModalVisible = !this.isDirectionModalVisible;
    },
  },
};
</script>

<style scoped>
.container {
  background-color: #ebeadf;
}
</style>