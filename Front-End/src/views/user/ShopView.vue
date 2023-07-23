<template>
  <div>
    <MainAnnouncement />
    <MainHeader :cart="cart" @cart-clicked="showCartModal" />
    <MenuCard @update-cart="updateCart" />
    <ScrollButton />
    <CartModal :cart="cart" :isCartModalVisible="isCartModalVisible" @close="closeCartModal"
      @remove-from-cart="removeFromCart" @update-cart="updateCart" />
    <MainFooter/>
  </div>
</template>

<script>
import MainAnnouncement from "@/components/Announcement/Announcement.vue";
import MainHeader from "@/components/Header/Header.vue";
import MainFooter from "@/components/Footer/Footer.vue"
import MenuCard from "@/components/MenuCard/MenuCard.vue";
import ScrollButton from "@/components/ScrollButton/ScrollButton.vue";
import CartModal from "@/components/CartModal/CartModal.vue";

export default {
  name: "ShopView",
  components: {
    MainAnnouncement,
    MainHeader,
    MenuCard,
    MainFooter,
    ScrollButton,
    CartModal,
  },
  data() {
    return {
      cart: [],
      isCartModalVisible: false,
      selectedMenu: null,
    };
  },
  methods: {

    removeFromCart(item) {
      const index = this.cart.findIndex((cartItem) => cartItem.title === item.title);
      if (index !== -1) {
        this.cart.splice(index, 1);
      }
    },
    updateCart(updatedCart) {
      this.cart = updatedCart;
    },
    showCartModal() {
      this.isCartModalVisible = true;
    },
    closeCartModal() {
      this.isCartModalVisible = false;
    },
  },
};
</script>
