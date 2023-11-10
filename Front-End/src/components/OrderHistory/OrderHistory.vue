<template>
  <div class="orders">
    <div v-if="pedidos.length === 0" class="no-orders-message">
      <p>No hay pedidos disponibles en este momento.</p>
    </div>
    <div v-else>
      <div v-for="(pedido, pedidoId) in pedidos" :key="pedidoId" class="order-container">
        <span class="value">{{ pedido.pedido_id || 'N/A' }} </span>
        <div class="container">
          <div class="menu-data menu-top">
            <div>
              <span class="label">Fecha del Pedido: </span>
              <span class="value">{{ pedido.fecha_del_pedido || 'N/A' }}</span>
            </div>
            <div>
              <span class="label">Estado Actual: </span>
              <span class="value">{{ pedido.estados[0] && pedido.estados[0].estado || 'N/A' }} </span>
            </div>
          </div>
          <div class="menu-container">
            <div v-for="(menu, menuId) in pedido.menus" :key="menuId" class="order-menu menu-data">
              <div>
                <span class="label">Menu: </span>
                <span class="value">{{ menu.nombre || 'N/A' }} </span>
              </div>

              <div>
                <span class="label">Cantidad: </span>
                <span class="value">{{ menu.cantidad || 'N/A' }} </span>
              </div>


              <div>
                <span class="label">Categoría: </span>
                <span class="value">{{ menu.categoria || 'N/A' }} </span>
              </div>

              <div>
                <span class="label">Precio: </span>
                <span class="value">{{ menu.precio * menu.cantidad || 'N/A' }} </span>
              </div>


            </div>
          </div>
          <div class="menu-data">
            <div>
              <ul class="direction">
                <li>
                  <span> {{ pedido.direccion[3] + ' ' || 'N/A' }} </span>

                  <span> {{ pedido.direccion[2] + ' ' || 'N/A' }} </span>

                  <span> {{ pedido.direccion[1] + ' ' || 'N/A' }} </span>

                  <span>{{ pedido.direccion[0] + ' ' || 'N/A' }} </span>
                </li>
              </ul>
            </div>
            <div>
              <span class="label">Costo del Pedido: </span>
              <span class="value">{{ calcularPrecioTotal(pedido.menus) || 'N/A' }} </span>
            </div>

          </div>
        </div>
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
      if (!menus) {
        return 0;
      }

      let totalPrecio = 0;
      const menuKeys = Object.keys(menus);
      for (const menuKey of menuKeys) {
        totalPrecio += menus[menuKey].precio * menus[menuKey].cantidad || 0;
        console.log(totalPrecio);
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
          console.log(response.data)
          if (Array.isArray(response.data)) {
            this.pedidos = response.data;
            console.log(this.pedidos)
          }
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
  border: 1px solid white;
  border-radius: 15px;
  height: 77.99vh;
  color: white;
  overflow-y: scroll;
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;

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
  height: 20vh;
  margin: 1em auto;
  width: 80%;
  border: 1px solid white;
  padding: 4em;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.menu-container {
  overflow-y: auto;
  border: 1px solid white;
}

.order-menu {
  background-color: #ebeadf;
  padding: .8em;
  color: black;
  margin: 15px;
  text-align: center;
}

.menu-data {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}

.menu-top {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.direction {
  display: flex;
  flex-direction: row;
  list-style-type: none;
}

.no-orders-message {
  padding: 3em;
  border: 1px solid white;
  width: 25vw;
  margin: 0 auto;
  border-radius: 15px;
  margin-top: 19vh;
}

.container {
  width: 60vw;
}
</style>
