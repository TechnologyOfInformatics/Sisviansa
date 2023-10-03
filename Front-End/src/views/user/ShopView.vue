<template>
  <div class="container">
    <MainAnnouncement />
    <MainHeader :cart="cart" @toggle-cart-modal="toggleCartModal" @toggle-direction-modal="toggleDirectionModal" />
    <DirectionModal :isDirectionModalVisible="isDirectionModalVisible" />
    <CartModal :cart="cart" :isCartModalVisible="isCartModalVisible" @remove-from-cart="removeFromCart"
      @update-cart="updateCart" />


    <MenuCard @update-cart="updateCart"  />
    <ScrollButton />

    <MainFooter />
  </div>
</template>

<script>
import MainAnnouncement from "@/components/Announcement/Announcement.vue";
import MainHeader from "@/components/Header/Header.vue";
import MainFooter from "@/components/Footer/Footer.vue";
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
    };
  },

  created() {
    const cartString = sessionStorage.getItem("cart");

    if (cartString) {
      this.cart = JSON.parse(cartString);
    }
  },
  methods: {

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