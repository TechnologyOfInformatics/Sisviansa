<template>
  <div class="orders">
    <div v-if="pedidos.length === 0" class="no-orders-message">
      <p>No hay pedidos disponibles en este momento.</p>
    </div>
    <div v-else>
      <div
        v-for="(pedido, pedidoId) in pedidos"
        :key="pedidoId"
        class="order-container"
      >
        <div class="menu-data">
          <div>
            <span class="label">ID del Pedido: </span>
            <span class="value">{{ pedido.pedido_id || "N/A" }} </span>
          </div>

          <div>
            <span class="label">Total Precio de Menús: </span>
            <span class="value"
              >{{ calcularPrecioTotal(pedido.menus) || "N/A" }}
            </span>
          </div>

          <div>
            <span class="label">Estado Actual:</span>
            <span class="value"
              >{{ (pedido.estados[0] && pedido.estados[0].estado) || "N/A" }}
            </span>
          </div>
        </div>

        <div
          v-for="(menu, menuId) in pedido.menus"
          :key="menuId"
          class="order-menu menu-data"
        >
          <div>
            <span class="label">Menus: </span>
            <span class="value">{{ menu.nombre || "N/A" }} </span>
          </div>

          <div>
            <span class="label">Cantidad: </span>
            <span class="value">{{ menu.cantidad || "N/A" }} </span>
          </div>

          <div>
            <span class="label">Frecuencia: </span>
            <span class="value">{{ menu.frecuencia || "N/A" }} </span>
          </div>

          <div>
            <span class="label">Categoría: </span>
            <span class="value">{{ menu.categoria || "N/A" }} </span>
          </div>

          <div>
            <span class="label">Precio: </span>
            <span class="value"
              >{{ menu.precio * menu.cantidad || "N/A" }}
            </span>
          </div>
        </div>

        <div class="menu-data">
          <div>
            <span class="label">Fecha del Pedido: </span>
            <span class="value">{{ pedido.fecha_del_pedido || "N/A" }}</span>
          </div>

          <div>
            <span class="label">Dirección de Entrega: </span>
            <ul class="direction">
              <li>
                <span>{{ pedido.direccion[3] || "N/A" }}</span>
              </li>
              <li>
                <span>{{ pedido.direccion[2] || "N/A" }}</span>
              </li>
              <li>
                <span>{{ pedido.direccion[1] || "N/A" }}</span>
              </li>
              <li>
                <span>{{ pedido.direccion[0] || "N/A" }}</span>
              </li>
            </ul>
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
        .post("http://sisviansa_php/server.php", dataToSend)
        .then((response) => {
          console.log(response.data);
          if (Array.isArray(response.data)) {
            this.pedidos = response.data;
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
  padding: 0.8em;
  color: black;
  margin: 15px;
}

.menu-data {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
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
</style>
