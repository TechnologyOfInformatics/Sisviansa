<template>
  <div class="container">
    <header class="header">
      <nav class="header__nav">
        <div class="header__logo">
          <h2>Sisviansa</h2>
        </div>
        <nav class="nav">
          <li :class="{ selected: $route.path === '/admin/user' }">
            <router-link to="/admin/user" class="link">Usuarios</router-link>
          </li>
          <li :class="{ selected: $route.path === '/admin/menu' }">
            <router-link to="/admin/menu" class="link">Menu</router-link>
          </li>
          <li :class="{ selected: $route.path === '/admin/chef' }">
            <router-link to="/admin/chef" class="link">Chef</router-link>
          </li>
        </nav>
        <div class="header__user-info">
          <span>Bienvenido, {{ username }}</span>
          <router-link v to="/admin/auth" class="link" @click="logout">
            <div class="action__button">
              <i class="fa-solid fa-right-to-bracket"></i>
            </div>
          </router-link>
        </div>
      </nav>
    </header>
    <main class="main">
      <aside class="sidebar">
        <nav class="sidebar__nav">
          <ul class="sidebar__list">
            <li><a @click="showCategory('users')" class="aside-link">Lista de Usuarios</a></li>
            <li><a @click="showCategory('auth')" class="aside-link">Autorizar Usuarios</a></li>
            <li><a @click="showCategory('createB')" class="aside-link">Crear empresa</a></li>
            <li><a @click="showCategory('orders')" class="aside-link">Pedidos</a></li>
          </ul>
        </nav>
        <footer class="sidebar__footer">Sisviansa</footer>
      </aside>
      <section class="main__section">
        <div v-if="currentCategory === 'users'" class="category-content">
          <h1 class="category-content__title">Información de Usuarios</h1>

          <div class="search-bar">
            <input type="text" v-model="searchQuery" placeholder="Buscar por ID, nombre o apellido">
            <button @click="searchUsers">Buscar</button>
          </div>

          <div v-if="filteredUsers.length === 0" class="no-results">
            <p>No se encontraron resultados.</p>
          </div>
          <table class="user-table" v-else>
            <div class="table-container">

              <thead>
                <tr>
                  <th>Cliente ID</th>
                  <th>Cliente tipo</th>
                  <th>Nombre</th>
                  <th>Documento Tipo</th>
                  <th>Documento</th>
                  <th>Teléfono</th>
                  <th>Correo</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in filteredUsers" :key="user.Cliente_ID">
                  <td>{{ user[0] }}</td>
                  <td>{{ user[1] }}</td>
                  <td>{{ user[2] }}</td>
                  <td>{{ user[3] }}</td>
                  <td>{{ user[4] }}</td>
                  <td v-if="user[5].length === 1">{{ user[5] }}</td>
                  <td v-else> <button @click="toggleUserDetails(user)">
                      {{ user.showDetails ? '-' : '+' }} </button></td>
                  <td>{{ user[6] }}</td>


                </tr>
              </tbody>
            </div>
          </table>
        </div>
        <div v-if="currentCategory === 'auth'" class="category-content">
          <h1 class="category-content__title">Autorización de Usuarios</h1>

          <div class="search-bar">
            <input type="text" v-model="searchQuery" placeholder="Buscar por ID, nombre o apellido">
            <button @click="searchUsers">Buscar</button>
          </div>

          <div v-if="filteredUsers.length === 0" class="no-results">
            <p>No se encontraron resultados.</p>
          </div>
          <table class="user-table" v-else>
            <div class="table-container">

              <thead>
                <tr>
                  <th>Cliente ID</th>
                  <th>Cliente tipo</th>
                  <th>Nombre</th>
                  <th>Documento Tipo</th>
                  <th>Documento</th>
                  <th>Correo</th>
                  <th>Autorizacion</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in filteredUsers" :key="user.Cliente_ID">
                  <td>{{ user[0] }}</td>
                  <td>{{ user[1] }}</td>
                  <td>{{ user[2] }}</td>
                  <td>{{ user[3] }}</td>
                  <td>{{ user[4] }}</td>

                  <td>{{ user[6] }}</td>
                  <select v-model="user[7]" @change="handleAutorizacionChange(user[7], user[0])">
                    <option value="Autorizado">Autorizado</option>
                    <option value="En espera">En espera</option>
                    <option value="No autorizado">No autorizado</option>
                  </select>

                </tr>
              </tbody>
            </div>
          </table>
        </div>
        <div v-if="currentCategory === 'createB'" class="category-content">
          <form @submit.prevent="registerBussines">

            <h1>Crear cuenta de Empresa</h1>
            <input v-model="nameb" type="text" name="txt" placeholder="Nombre" required autocomplete="name" id="nameb" />
            <input v-model="rut" type="text" name="txt" placeholder="Rut" required id="rut" />
            <input v-model="mailb" type="email" name="email" placeholder="Correo electrónico" required
              autocomplete="email" id="mailb" />
            <input v-model="passwdb" type="password" name="passwdb" placeholder="Contraseña" required
              autocomplete="new-password" id="passwdb" />
            <input v-model="confirmPasswdb" type="password" name="confirmPasswdb" placeholder="Confirma la contraseña"
              required autocomplete="new-password" id="confirmPasswdb" />
            <div v-if="errorMessage" class="error-message">
              {{ errorMessage }}
            </div>
            <div v-if="succesMessage" class="succes-message">
              {{ succesMessage }}
            </div>

            <button type="submit">Registrate</button>

          </form>

        </div>

        <div v-if="currentCategory === 'orders'" class="category-content">
          <h1 class="category-content__title">Pedidos de los clientes</h1>

          <div class="search-bar">
            <input type="text" v-model="searchQuery" placeholder="Buscar por ID, nombre o apellido">
            <button @click="searchOrders">Buscar</button>
          </div>

          <div v-if="filteredOrders.length === 0" class="no-results">
            <p>No se encontraron resultados.</p>
          </div>
          <table class="user-table" v-else>
            <div class="table-container">

              <thead>
                <tr>
                  <th>Pedido ID</th>
                  <th>Pedido Fecha</th>
                  <th>Menus</th>
                  <th>Cantidad</th>
                  <th>Estado</th>
                  <th>Nombre Comprador</th>
                  <th>Documento Comprador</th>
                  <th>Precio del Pedido</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="order in filteredOrders" :key="order.pedido_id">
                  <td>{{ order.pedido_id }}</td>
                  <td>{{ order.fecha_del_pedido }}</td>
                  <td>
                    <span v-for="(menu, index) in order.menus" :key="index">
                      {{ menu.nombre }}
                      <span v-if="index < order.menus.length - 1"> <br> </span>
                    </span>
                  </td>
                  <td> <span v-for="(menu, index) in order.menus" :key="index">
                      {{ menu.cantidad }}
                      <span v-if="index < order.menus.length - 1"><br> </span>
                    </span></td>
                  <td>{{ order.estados[0].estado }}</td>
                  <td>{{ order.nombre }}</td>
                  <td>{{ order.documento }}</td>
                  <td>
                    {{ order.menus ? Object.values(order.menus).reduce((total, menu) => total + (menu.precio ?
                      parseFloat(menu.precio) : 0), 0).toFixed(2) : 0 }}
                  </td>

                </tr>
              </tbody>
            </div>
          </table>
        </div>
      </section>


      <!-- modals -->
      <div v-if="showModal" class="modal">
        <div class="modal-content">
          <h2>Detalles del Usuario</h2>
          <table class="user-details-table">
            <tbody>
              <tr>
                <td>Cliente ID:</td>
                <td>{{ selectedUser[0] }}</td>
              </tr>
              <tr>
                <td>Documento Número:</td>
                <td>{{ selectedUser[4] }}</td>
              </tr>
              <tr>
                <td>Telefonos:</td>
                <td>
                  <p v-for="(telefono, index) in selectedUser[5]" :key="index"> {{ telefono }}</p>
                </td>
              </tr>
            </tbody>
          </table>
          <button @click="showModal = false; showModalUser = false">Cerrar</button>

        </div>
      </div>

    </main>
  </div>
</template>
  
  
<script>
export default {
  data() {
    return {
      currentCategory: null,
      username: "Nombre de Usuario",
      users: [],
      orders: [],
      searchQuery: "",
      selectedUser: null, // Para almacenar el usuario seleccionado para mostrar en el modal
      showModal: false, // Para controlar la visibilidad del modal
      filteredUsers: [],
      filteredOrders: [],
      searchTerm: "",
      modifyingUser: null,
      editingField: null,
      showModalUser: false,
      errorMessage: '',
      succesMessage: '',
      nameb: "",
      rut: "",
      mailb: "",
      passwdb: "",
      confirmPasswdb: "",

    };
  },
  mounted() {
    this.fetchUsers();
    this.fetchOrders();

  },
  methods: {
    changeUserDetails(user, field) {
      this.modifyingUser = user;
      this.editingField = field;
      this.showModalUser = true
    },
    showCategory(category) {
      this.currentCategory = category;
    },
    closeModal() {
      this.showModal = false;

    },
    logout() {

    },
    toggleUserDetails(user) {
      if (user.showDetails) {
        user.showDetails = false;
        this.closeModal()
      } else {
        user.showDetails = true;
        this.selectedUser = user;
        this.showModal = true;
      }
    },
    handleAutorizacionChange(state, id) {

      const dataToSend = {
        functionName: "admin_toggle_client_state",
        cid: id,
        cstate: state
      };
      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)

        })
        .catch((error) => {
          console.error(error);
        });
    },
    saveUserChanges() {

      this.showModal = false;

      this.updateUserList();
    },
    fetchUsers() {
      const dataToSend = {
        functionName: "admin_show_user_list",

      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
          console.log(response.data)

          if (Array.isArray(response.data)) {
            this.users = response.data
            console.log(this.users)
            this.searchUsers();
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    fetchOrders() {
      const dataToSend = {
        functionName: "admin_get_orders",
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
          if (Array.isArray(response.data)) {
            this.orders = response.data
            console.log(this.users)
            this.searchOrders();
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    searchUsers() {
      this.closeModal();


      const query = this.searchQuery.toLowerCase().trim();

      if (query === "") {
        this.filteredUsers = this.users;
        this.filteredUsers = this.users.map((user) => {
          return { ...user, showDetails: false };
        })
      } else {
        this.filteredUsers = this.users.filter((user) => {
          const idMatch = user[0].toString().includes(query);
          const telefonoMatch = user[5].toString().includes(query);
          const tipoDocumentoMatch = user[3].toLowerCase().includes(query);
          const numeroDocumentoMatch = user[4].toString().includes(query);
          const nombre = user[2].toLowerCase().includes(query);


          return (
            idMatch ||
            telefonoMatch ||
            tipoDocumentoMatch ||
            numeroDocumentoMatch ||
            nombre

          );
        });
        if (this.filteredUsers.length === 0) {
          this.filteredUsers = [];
        }
      }
    },
    searchOrders() {
      const query = this.searchQuery.toLowerCase().trim();

      if (query === "") {
        this.filteredOrders = this.orders;
        this.filteredOrders = this.orders.map((order) => {
          return { ...order };
        })
      } else {
        this.filteredOrders = this.orders.filter((order) => {
          const id = order.pedido_id.toString().includes(query);
          const nombre = order.nombre.toLowerCase().includes(query);
          const estado = order.estados[0].estado.toLowerCase().includes(query);
          const documento = order.documento.toString().includes(query);
          const nombreMenu = Array.isArray(order.menus) && order.menus.some(menu => menu.nombre.toLowerCase().includes(query));

          return (
            id ||
            nombre ||
            estado ||
            documento ||
            nombreMenu

          );
        });
        if (this.filteredUsers.length === 0) {
          this.filteredUsers = [];
        }
      }
    },
    registerBussines() {
      if (this.passwd !== this.confirmPasswd) {
        this.errorMessage = 'Error, las contrase;as no coinciden.'
        return;
      }

      const dataToSend = {
        functionName: "admin_register_business",
        name: this.nameb,
        doc: this.rut,
        mail: this.mailb,
        passwd: this.passwdb,
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          if (response.data == "Error 404") {
            this.errorMessage = 'Error creando la empresa'
          } else {
            this.succesMessage = "Cuenta creada"
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
  },
};
</script>

  
<style lang="css" scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;

}

body {
  width: 100vw;
  height: 100vh;
  font-family: 'Arial', sans-serif;
}

*::-webkit-scrollbar {
  width: 6px;
}

*::-webkit-scrollbar-track {
  background-color: transparent;
}

*::-webkit-scrollbar-thumb {
  background-color: #999999;
  border-radius: 3px;
}

*::-webkit-scrollbar-thumb:hover {
  background-color: #888888;
}

form {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  color: white;
}

input {
  width: 100%;
  padding: 10px;
  margin: 8px 0;
  box-sizing: border-box;
}

.error-message {
  color: red;
  margin-top: 10px;
}

.success-message {
  color: green;
  margin-top: 10px;
}

button {

  background-color: white;
  color: black;
  padding: 10px 15px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

button:hover {
  background-color: #45a049;
}

.nav {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  color: white;
}

.nav li {
  text-decoration: none;
  list-style: none;
  padding-left: 10px;
}

.nav li .link {
  color: white;
  text-decoration: none;
}

.aside-link {
  color: black;
}

.container {
  display: flex;
  flex-direction: column;
  height: 90vh;
}

.header {
  background: #263f65;
  color: #fff;
  padding: 10px 20px;
  height: auto;
  border-top-right-radius: 15px;
  border-top-left-radius: 15px;
  border-bottom-right-radius: 15px;
}

.header__nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header__logo h2 {
  font-size: 3em;
  margin-left: 2vw;
}

.header__user-info {
  margin-right: 20px;
}

.header__user-info span {
  font-weight: bold;
}

.header__user-info {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;

}

.header__user-info div i {
  margin-left: 10px;
  padding: 10px;
  color: white;
  text-decoration: none;
  border: 1px solid white;
  border-radius: 30px;
}

.modal {
  height: 60vh;
  background-color: #263f65;
  border-radius: 15px;
  padding: 2em;
  margin-top: 15vh;
  width: 20vw;
}

.sidebar {
  width: 20%;
  height: 86.5vh;
  background: #263f65;
  color: #fff;
  padding: 20px;
  display: flex;
  flex-direction: column;
  border-bottom-right-radius: 15px;
  border-bottom-left-radius: 15px;

}

.sidebar__nav {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.sidebar__list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar__list li {
  text-align: center;
  margin-bottom: 1.5em;
  background-color: #f4f4f4;
  border-radius: 10px;
  width: 100%;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.sidebar__list li:hover {
  background-color: #e0e0e0;
}

.sidebar__footer {
  margin-top: auto;
  text-align: center;
}

.search-bar {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  /* Espacio entre la barra de búsqueda y la tabla */
}

.search-bar input[type="text"] {
  flex-grow: 1;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  margin-right: 10px;
  /* Espacio entre el campo de búsqueda y el botón */
}

.search-button {
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 10px 15px;
  border-radius: 5px;
  cursor: pointer;
}

.search-button:hover {
  background-color: #0056b3;
}

.main {
  flex-grow: 1;
  display: flex;
}

.main__section {
  margin: 1vw;
  flex-grow: 1;
  padding: 20px;
  background: #263f65;
  height: 83.9vh;
  border-radius: 15px;
  overflow-y: auto;

}

.category-content__title {
  font-size: 24px;
  margin-bottom: 10px;
}


/* Estilos para la tabla de usuarios */
.user-table {
  border-collapse: collapse;
  background-color: #fff;
}

.table-container {
  height: 60vh;
  overflow-y: auto;

}

.user-table th,
.user-table td {
  padding: 10px;
  text-align: center;
  border: 1px solid #ddd;
}

.user-table .modify:hover {
  background-color: #999999;
  cursor: pointer;
}

.user-table th {
  background-color: #333;
  color: #fff;
}

.user-table tbody tr:nth-child(even) {
  background-color: #f8f8f8;
}

.user-details-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
}

.user-table tbody select {
  width: 100%;
  cursor: pointer;
  height: 6vh;
  background-color: transparent;
  outline: none;
  border: 1px solid #ddd;

}


.user-details-table td {
  padding: 10px;
  text-align: left;
  border: 1px solid #ddd;
}

.user-details-table tr:nth-child(even) {
  background-color: #f8f8f8;
}

.user-table button {
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
  cursor: pointer;
}

.user-table button:hover {
  background-color: #0056b3;
}
</style>
  