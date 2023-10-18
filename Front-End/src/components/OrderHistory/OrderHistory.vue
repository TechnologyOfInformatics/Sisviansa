<template>
  <div class="orders">
    <div v-for="(pedido, pedidoId) in pedidos" :key="pedidoId" class="order-container">
      <div>
        <span class="label">ID del Pedido: </span>
        <span class="value">{{ pedido.pedido_id || 'N/A' }} </span>

        <span class="label">Total Precio de Menús: </span>
        <span class="value">{{ calcularPrecioTotal(pedido.menus) || 'N/A' }} </span>

        <span class="label">Estado Actual:</span>
        <span class="value">{{ pedido.estados[0] && pedido.estados[0].estado || 'N/A' }} </span>

        <div v-for="(menu, menuId) in pedido.menus" :key="menuId" class="order-menu">
          <span class="label">Menus: </span>
          <span class="value">{{ menu.nombre || 'N/A' }} </span>
          <span class="label">Frecuencia: </span>
          <span class="value">{{ menu.frecuencia || 'N/A' }} </span>

          <span class="label">Categoría: </span>
          <span class="value">{{ menu.categoria || 'N/A' }} </span>

          <span class="label">Precio: </span>
          <span class="value">{{ menu.precio || 'N/A' }} </span>


        </div>
      </div>

      <div>
        <span class="label">Fecha del Pedido: </span>
        <span class="value">{{ pedido.fecha_del_pedido || 'N/A' }}</span>

        <span class="label">Dirección de Entrega: </span>
        <li v-for="(direccion, index) in pedido.direccion" :key="index">{{ direccion || 'N/A' }}</li>


      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      pedidos: [],
    };
  },
  created() {
    this.fetchPedidosFromBackend();
  },

  methods: {
    calcularPrecioTotal(menus) {
      let totalPrecio = 0;
      const menuKeys = Object.keys(menus);
      for (const menuKey of menuKeys) {
        totalPrecio += menus[menuKey].precio || 0;
      }
      return totalPrecio;
    },
    fetchPedidosFromBackend() {
      const dataToSend = {
        functionName: "options_get_orders",
        token: sessionStorage.getItem("miToken") || 0,
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data);
          this.pedidos = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
  },
};
</script>

<style scoped>
.orders {
  background-color: #243328;
  margin-bottom: 1em;
  overflow-y: auto;
  height: 77.5vh;
  color: white;
  padding: 2em 0;

}

.orders::-webkit-scrollbar {
  width: 6px;
}

.orders::-webkit-scrollbar-track {
  background-color: transparent;
}

.orders::-webkit-scrollbar-thumb {
  background-color: #999999;
  border-radius: 3px;
}

.orders::-webkit-scrollbar-thumb:hover {
  background-color: #888888;
}

.order-container {
  height: 30vh;
  margin: 1em auto;
  width: 80%;
  border: 1px solid white;
  padding: 4em;
}

.order-menu {
  background-color: #ebeadf;
  padding: .8em;
  color: black;
  margin: 15px;
}
</style>
