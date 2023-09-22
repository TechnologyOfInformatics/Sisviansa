<template>
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
</template>

<script>
export default {
  props: {
    menusData: Array, // Propiedad para recibir los datos de menús desde el componente padre
  },
  data() {
    return {
      cart: [], // Aquí se almacenarán los elementos del carrito
    };
  },
  computed: {
    cartTotal() {
      return this.cart.reduce((total, item) => total + item.price * item.quantity, 0);
    },
  },
  methods: {
    incrementQuantity(item) {
      item.quantity++;
    },
    decrementQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
      }
    },
    removeFromCart(item) {
      const index = this.cart.indexOf(item);
      if (index !== -1) {
        this.cart.splice(index, 1);
      }
    },
    checkout() {
      if (this.cart.length === 0) {
        return;
      }
      // Lógica para el proceso de compra
      // Aquí podrías redirigir al usuario a la página de pago o confirmación
    },
  },
};
</script>