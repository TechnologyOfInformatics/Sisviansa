<template>
  <MainHeader />
  <div class="cart">
    <h2>Carrito de Compras</h2>
    <div v-if="cart.length === 0">Tu carrito está vacío.</div>
    <div v-else>
      <div v-for="(item, index) in cart" :key="index" class="cart-item">
        <div class="item-details">
          <h3>{{ item.title }}</h3>
          <p>Precio: ${{ item.price }}</p>
          <p>Calorías: {{ item.calories }}</p>
          <p>Descripción: {{ item.description }}</p>
          <div>
            Cantidad:
            <button @click="decrementQuantity(item)" :disabled="item.quantity === 1">-</button>
            {{ item.quantity }}
            <button @click="incrementQuantity(item)">+</button>
          </div>
          <button @click="removeFromCart(item)">Eliminar</button>
        </div>
      </div>
      <div class="cart-summary">
        <p>Total: ${{ cartTotal }}</p>
        <button @click="checkout" :disabled="cart.length === 0">Finalizar Compra</button>
      </div>
    </div>
  </div>
  <MainFooter />
</template>

<script>
import MainHeader from '@/components/Header/Header.vue'
import MainFooter from '@/components/Footer/Footer.vue'
export default {
  components: {
    MainFooter,
    MainHeader,
  },
  data() {
    return {
      login: true,
      cart: [],
    };
  },
  created() {
    const cartString = sessionStorage.getItem("cart");
    if (cartString) {
      this.cart = JSON.parse(cartString);
    }
  },
  computed: {
    cartTotal() {
      return this.cart.reduce((total, item) => total + item.price * item.quantity, 0);
    },
  },
  methods: {
    incrementQuantity(item) {
      item.quantity++;
      this.updateCart();
    },
    decrementQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
        this.updateCart();
      }
    },
    removeFromCart(item) {
      const index = this.cart.indexOf(item);
      if (index !== -1) {
        this.cart.splice(index, 1);
        this.updateCart();
      }
    },
    checkout() {
      if (this.cart.length === 0) {
        return;
      }
      // Lógica de finalización de la compra
    },
    updateCart() {
      const cartString = JSON.stringify(this.cart);
      sessionStorage.setItem("cart", cartString);
    },
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
}

</script>
<style scoped>
.cart {
  width: 80%;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  background-color: #f9f9f9;
  border-radius: 5px;
}

.cart-title {
  font-size: 24px;
  margin-bottom: 10px;
}

.empty-cart {
  font-size: 18px;
  color: #555;
}

.cart-item {
  margin: 10px 0;
  padding: 10px;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 5px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-details {
  flex: 1;
}

.item-price {
  font-weight: bold;
}

.quantity-control {
  display: flex;
  align-items: center;
  margin-top: 10px;
}

.quantity-button {
  margin: 0 5px;
  padding: 5px 10px;
  background-color: #007bff;
  color: #fff;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}

.remove-button {
  background-color: #dc3545;
  color: #fff;
  border: none;
  cursor: pointer;
  padding: 5px 10px;
  border-radius: 5px;
}

.cart-summary {
  margin-top: 20px;
  text-align: right;
}

.total {
  font-size: 20px;
  font-weight: bold;
}

.checkout-button {
  background-color: #28a745;
  color: #fff;
  border: none;
  cursor: pointer;
  padding: 10px 20px;
  border-radius: 5px;
  font-size: 18px;
}
</style>