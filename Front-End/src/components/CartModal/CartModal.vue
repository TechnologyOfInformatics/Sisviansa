<template>
  <div v-show="isCartModalVisible">
    <div class="cart-modal" :style="{ transform: `translate(61vw, -${translateY}vh)` }">
      <button class="close-button" @click="toggleCartModal">
        <i class="fa-solid fa-circle-xmark"></i>
      </button>
      <div class="cart-modal-content">

        <div class="cart-items">
          <div v-if="cart.length === 0" class="empty-cart-message">
            <span>Su carrito está vacío</span>
          </div>
          <div v-else>
            <div v-for="item in cart" :key="item.title" class="cart-item">
              <div class="cart-item-info">
                <span class="item-title">{{ item.title }}</span>
                <span class="item-price">{{ item.price }} USD</span> <span class="item-type">Vegan</span>
                <!-- {{ item.diets }} -->
              </div>
              <div class="quantity-controls">
                <button class="quantity-button" @click.stop="decreaseQuantity(item)" :disabled="item.quantity === 1">
                  <i class="fa-solid fa-sort-down"></i>
                </button>
                <span class="quantity">{{ item.quantity }}</span>
                <button class="quantity-button" @click.stop="increaseQuantity(item)">
                  <i class="fa-solid fa-sort-up"></i>
                </button>
              </div>
              <button class="remove-item-btn" @click.stop="removeFromCart(item)">
                <i class="fa-solid fa-trash"></i>
              </button>
            </div>
          </div>
        </div>
        <div v-if="cart.length > 0" class="cart-buttons">
          <router-link to="/cart" class="link">
            <button class="complete-purchase-btn">Completar compra</button>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "CartModal",
  props: {
    cart: {
      type: Array,
      default: () => [],
    },
    isCartModalVisible: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      translateY: 10,
      hasScrolled: false,
    };
  },
  methods: {
    toggleCartModal() {
      this.$emit("toggle-cart-modal");
    },
    removeFromCart(item) {
      this.$emit("remove-from-cart", item);
    },

    increaseQuantity(item) {
      item.quantity++;
      this.$emit("update-cart", this.cart);
    },
    decreaseQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
        this.$emit("update-cart", this.cart);
      }
    },

    handleScroll() {
      const scrollThreshold = 2.5 * window.innerHeight / 100;

      if (!this.hasScrolled && window.scrollY >= scrollThreshold) {
        this.translateY += 4;
        this.hasScrolled = true;
      } else if (this.hasScrolled && window.scrollY < scrollThreshold) {
        this.translateY -= 4;
        this.hasScrolled = false;
      }
    },

  },
  mounted() {
    window.addEventListener("scroll", this.handleScroll);
  },
};
</script>


<style lang="css" src="./CartModal.css" scoped></style>
