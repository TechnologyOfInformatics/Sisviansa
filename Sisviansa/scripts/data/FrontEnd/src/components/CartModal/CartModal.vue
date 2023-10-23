<template>
  <div v-show="isCartModalVisible">
    <div class="cart-modal-overlay" @click="closeModal"></div>
    <div class="cart-modal">
      <div class="cart-modal-content">
        <button class="close-button" @click="closeModal">
          <i class="fa-solid fa-circle-xmark"></i>
        </button>
        <div class="cart-items">
          <div v-if="cart.length === 0" class="empty-cart-message">
            <span>Su carrito está vacío</span>
          </div>
          <div v-else>
            <div v-for="item in cart" :key="item.title" class="cart-item">
              <div class="cart-item-info">
                <span class="item-title">{{ item.title }}</span>
                <span class="item-price">{{ item.price }} USD</span>
              </div>
              <div class="quantity-controls">
                <button
                  class="quantity-button"
                  @click.stop="decreaseQuantity(item)"
                  :disabled="item.quantity === 1"
                >
                  -
                </button>
                <span class="quantity">{{ item.quantity }}</span>
                <button
                  class="quantity-button"
                  @click.stop="increaseQuantity(item)"
                >
                  +
                </button>
              </div>
              <button
                class="remove-item-btn"
                @click.stop="removeFromCart(item)"
              >
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

  methods: {
    removeFromCart(item) {
      this.$emit("remove-from-cart", item);
    },
    closeModal() {
      this.$emit("close");
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
  },
};
</script>

<style scoped>
.cart-modal {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: white;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 4px;
  width: 400px;
  z-index: 9999;
}

.cart-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 9998;
}

.close-button {
  width: 30px;
  font-size: 18px;
  font-weight: bold;
  display: flex;
  align-self: right;
  cursor: pointer;
  background-color: transparent;
  border: none;
}

.cart-items {
  margin-bottom: 10px;
}

.empty-cart-message {
  text-align: center;
  margin-bottom: 10px;
}

.cart-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}

.cart-item-info {
  display: flex;
  flex-direction: column;
}

.item-title {
  font-weight: bold;
}

.item-price {
  color: #777;
}

.quantity-controls {
  display: flex;
  align-items: center;
}

.quantity-button {
  background-color: #f5f5f5;
  border: 1px solid #ccc;
  color: #555;
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
}

.quantity-button:hover {
  background-color: #ebebeb;
}

.quantity {
  margin: 0 10px;
}

.remove-item-btn {
  background-color: #dc3545;
  color: white;
  border: none;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
}

.remove-item-btn i {
  display: inline-block;
  vertical-align: middle;
  margin-right: 5px;
}

.cart-buttons {
  display: flex;
  justify-content: flex-end;
  margin-top: 10px;
}

.complete-purchase-btn {
  background-color: #4287f5;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}

.complete-purchase-btn:hover {
  background-color: #0f5ed7;
}
</style>
