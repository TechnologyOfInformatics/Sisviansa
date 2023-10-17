<template>
    <div>
      <h1>Mis Pedidos</h1>
      <ul class="pedido-list">
        <li v-for="(pedido, pedidoId) in pedidos" :key="pedidoId" class="pedido-item">
          <div class="pedido-info">
            <div class="pedido-item">
              <span class="label">Nombre del Pedido:</span>
              <span>{{ pedido[1].nombre }}</span>
            </div>
            <div class="pedido-item">
              <span class="label">Frecuencia:</span>
              <span>{{ pedido[1].frecuencia }}</span>
            </div>
            <div class="pedido-item">
              <span class="label">Categoría:</span>
              <span>{{ pedido[1].categoria }}</span>
            </div>
            <div class="pedido-item">
              <span class="label">Precio:</span>
              <span>{{ pedido[1].precio }}</span>
            </div>
            <div class="pedido-item">
              <span class="label">Fecha del Pedido:</span>
              <span>{{ pedido.fecha_del_pedido }}</span>
            </div>
            <div class="pedido-item">
              <span class="label">Dirección de Entrega:</span>
              <ul>
                <li v-for="(direccion, index) in pedido.direccion" :key="index">{{ direccion }}</li>
              </ul>
            </div>
            <div class="pedido-item">
              <span class="label">Estado Actual:</span>
              <span>{{ pedido.estados[0].estado }}</span>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </template>
  
  
<script>
export default {
    data() {
        return {
            pedidos: []
        };
    },
    created() {
        this.fetchPedidosFromBackend();
    },
    methods: {
        fetchPedidosFromBackend() {
            const dataToSend = {
                functionName: "options_get_orders",
                token: sessionStorage.getItem('miToken') || 0,
            };

            this.$http
                .post("http://localhost/Back-End/server.php", dataToSend)
                .then((response) => {
                    console.log(response.data)
                    this.pedidos = response.data;

                })
                .catch((error) => {
                    console.error(error);
                });

        }
    }
};
</script>
  
<style scoped>
.pedido-list {
    list-style: none;
    padding: 0;
}

.pedido-item {
    border: 1px solid #ccc;
    padding: 10px;
    margin: 10px 0;
    background-color: #f5f5f5;
}

.pedido-info {
    display: flex;
    flex-wrap: wrap;
}

.label {
    font-weight: bold;
    width: 150px;
    margin-right: 10px;
}
</style>
  