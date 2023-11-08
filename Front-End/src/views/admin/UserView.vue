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
            <li><a @click="showCategory('mod')" class="aside-link">Modificar Usuarios</a></li>
            <li><a @click="showCategory('orders')" class="aside-link">Pedidos</a></li>

          </ul>
        </nav>
        <footer class="sidebar__footer">Sisviansa</footer>
      </aside>
      <section class="main__section">
        <div v-if="currentCategory === 'users'" class="category-content">
          <h1 class="category-content__title">User Information</h1>

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
                  <th>Documento</th>
                  <th>Documento Tipo</th>
                  <th>Teléfono</th>
                  <th>Correo</th>
                  <th>Primer Nombre</th>
                  <th>Segundo Nombre</th>
                  <th>Primer Apellido</th>
                  <th>Segundo Apellido</th>
                  <th>Dirección</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in filteredUsers" :key="user.Cliente_ID">
                  <td>{{ user.Cliente_ID }}</td>
                  <td> {{ user.type }}</td>
                  <td>{{ user.Documento_tipo }}</td>
                  <td>{{ user.Documento_numero }}</td>
                  <td>{{ user.Telefono }}</td>
                  <td>{{ user.Correo }}</td>
                  <td>{{ user.Primer_nombre }}</td>
                  <td>{{ user.Segundo_nombre }}</td>
                  <td>{{ user.Primer_apellido }}</td>
                  <td>{{ user.Segundo_apellido }}</td>
                  <td>
                    <button @click="toggleUserDetails(user)">
                      {{ user.showDetails ? '-' : '+' }}
                    </button>
                  </td>
                </tr>
              </tbody>
            </div>
          </table>
        </div>
        <div v-if="currentCategory === 'auth'" class="category-content">
          <h1 class="category-content__title">User Information</h1>

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
                  <th>Documento</th>
                  <th>Documento Tipo</th>
                  <th>Teléfono</th>
                  <th>Correo</th>
                  <th>Primer Nombre</th>
                  <th>Segundo Nombre</th>
                  <th>Primer Apellido</th>
                  <th>Segundo Apellido</th>
                  <th>Autorizacion</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in filteredUsers" :key="user.Cliente_ID">
                  <td>{{ user.Cliente_ID }}</td>
                  <td>{{ user.Documento_numero }}</td>
                  <td>{{ user.Documento_tipo }}</td>
                  <td v-if="user.Telefono.length === 1">{{ user.Telefono }}</td>
                  <td v-else> <button @click="toggleUserDetails(user)">
                      {{ user.showDetails ? '-' : '+' }} </button></td>
                  <td>{{ user.Correo }}</td>
                  <td>{{ user.Primer_nombre }}</td>
                  <td>{{ user.Segundo_nombre }}</td>
                  <td>{{ user.Primer_apellido }}</td>
                  <td>{{ user.Segundo_apellido }}</td>
                  <select v-model="user.Autorizacion">
                    <option value="Si">Si</option>
                    <option value="No">No</option>
                    <option value="Denegado">Denegado</option>
                  </select>
                </tr>
              </tbody>
            </div>
          </table>
        </div>
        <div v-if="currentCategory === 'mod'" class="category-content">
          <h1 class="category-content__title">User Information</h1>

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
                  <th>Documento</th>
                  <th>Documento Tipo</th>
                  <th>Telefono</th>
                  <th>Correo</th>
                  <th>Primer Nombre</th>
                  <th>Segundo Nombre</th>
                  <th>Primer Apellido</th>
                  <th>Segundo Apellido</th>
                  <th>Dirección</th>
                </tr>
              </thead>

              <tbody>
                <tr v-for="user in filteredUsers" :key="user.Cliente_ID">
                  <td>{{ user.Cliente_ID }}</td>
                  <td>{{ user.Cliente_tipo }}</td>
                  <td>{{ user.Documento_numero }}</td>
                  <td>{{ user.Telefono }}</td>
                  <td>{{ user.Documento_tipo }}</td>
                  <td @click="changeUserDetails(user, 'Correo')" class="modify">{{ user.Correo }}</td>

                  <td @click="changeUserDetails(user, 'Primer_nombre')" class="modify">{{ user.Primer_nombre }}</td>
                  <td @click="changeUserDetails(user, 'Segundo_nombre')" class="modify">{{ user.Segundo_nombre }}</td>
                  <td @click="changeUserDetails(user, 'Primer_apellido')" class="modify">{{ user.Primer_apellido }}</td>
                  <td @click="changeUserDetails(user, 'Segundo_apellido')" class="modify">{{ user.Segundo_apellido }}</td>
                  <td> <button @click="toggleUserDetails(user)">
                      {{ user.showDetails ? '-' : '+' }} </button>
                  </td>
                </tr>
              </tbody>
            </div>
          </table>
        </div>

        <div v-if="currentCategory === 'orders'" class="category-content">
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
                <td>{{ selectedUser.Cliente_ID }}</td>
              </tr>
              <tr>
                <td>Documento Número:</td>
                <td>{{ selectedUser.Documento_numero }}</td>
              </tr>
              <tr @click="changeUserDetails(selectedUser, 'Direccion')">
                <td>Dirección:</td>
                <td>
                  {{ selectedUser.Direccion.Numero }},
                  {{ selectedUser.Direccion.Calle }},
                  {{ selectedUser.Direccion.Barrio }},
                  {{ selectedUser.Direccion.Ciudad }}
                </td>
              </tr>
            </tbody>
          </table>
          <button @click="showModal = false; showModalUser = false">Cerrar</button>

        </div>
      </div>
      <div v-if="showModalUser" class="modal">
        <div class="modal-content">
          <h2>Modificar {{ editingField }}</h2>
          <form @submit.prevent="saveUserChanges">
            <table class="user-details-table">
              <tr v-if="editingField === 'Cedula'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Cedula" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Telefono'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Telefono" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Documento_tipo'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Documento_tipo" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Documento_numero'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Documento_numero" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Primer_nombre'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Primer_nombre" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Segundo_nombre'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Segundo_nombre" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Primer_apellido'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Primer_apellido" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Segundo_apellido'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Segundo_apellido" type="text">
                </td>
              </tr>
              <tr v-if="editingField === 'Direccion'">
                <td>{{ editingField }}:</td>
                <td>
                  <input v-model="modifyingUser.Direccion.Numero" type="text">
                  <input v-model="modifyingUser.Direccion.Calle" type="text">
                  <input v-model="modifyingUser.Direccion.Barrio" type="text">
                  <input v-model="modifyingUser.Direccion.Ciudad" type="text">
                </td>
              </tr>
            </table>
            <button @click="this.showModalUser = false">Cerrar</button>
            <button type="submit">Guardar Cambios</button>
          </form>
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
      users: [
        {
          Cliente_ID: 1,
          Telefono: "1234567890",
          Documento_tipo: "Cédula",
          Documento_numero: "123456789",
          Primer_nombre: "John",
          Segundo_nombre: "Doe",
          Primer_apellido: "Smith",
          Segundo_apellido: "Johnson",
          Autorizacion: "Si",
          Direccion: {
            Numero: "123",
            Calle: "Main St",
            Barrio: "Barrio Ejemplo",
            Ciudad: "Ciudad Ejemplo"
          },
        },
        {

          Cliente_ID: 2,
          Telefono: "9876543210",
          Documento_tipo: "Cédula",
          Documento_numero: "987654321",
          Primer_nombre: "Alice",
          Segundo_nombre: "Jane",
          Primer_apellido: "Brown",
          Segundo_apellido: "Davis",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "456",
            Calle: "Oak St",
            Barrio: "Barrio de Ejemplo",
            Ciudad: "Ciudad de Ejemplo"
          },
        },
        {
          Cliente_ID: 3,
          Telefono: "5555555555",
          Documento_tipo: "Pasaporte",
          Documento_numero: "555555555",
          Primer_nombre: "Eduardo",
          Segundo_nombre: "Pablo",
          Primer_apellido: "López",
          Segundo_apellido: "González",
          Contrasenia: "********",
          Autorizacion: "No",
          Direccion: {
            Numero: "789",
            Calle: "Maple St",
            Barrio: "Barrio de Prueba",
            Ciudad: "Ciudad de Prueba"
          },
        },
        {
          Cliente_ID: 4,
          Telefono: "1111111111",
          Documento_tipo: "Cédula",
          Documento_numero: "111111111",
          Primer_nombre: "Maria",
          Segundo_nombre: "Isabel",
          Primer_apellido: "Martínez",
          Segundo_apellido: "López",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "567",
            Calle: "Pine St",
            Barrio: "Barrio de Ejemplo",
            Ciudad: "Ciudad de Ejemplo"
          },
        },
        {
          Cliente_ID: 5,
          Telefono: "2222222222",
          Documento_tipo: "Cédula",
          Documento_numero: "222222222",
          Primer_nombre: "Carlos",
          Segundo_nombre: "Andrés",
          Primer_apellido: "Ramirez",
          Segundo_apellido: "Gómez",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "101",
            Calle: "Cedar St",
            Barrio: "Barrio de Prueba",
            Ciudad: "Ciudad de Prueba"
          },
        },
        {
          Cliente_ID: 6,
          Telefono: "3333333333",
          Documento_tipo: "Cédula",
          Documento_numero: "333333333",
          Primer_nombre: "Laura",
          Segundo_nombre: "Isabel",
          Primer_apellido: "Perez",
          Segundo_apellido: "González",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "222",
            Calle: "Elm St",
            Barrio: "Barrio de Ejemplo",
            Ciudad: "Ciudad de Ejemplo"
          },
        },
        {
          Cliente_ID: 7,
          Telefono: "4444444444",
          Documento_tipo: "Pasaporte",
          Documento_numero: "444444444",
          Primer_nombre: "Javier",
          Segundo_nombre: "Andrés",
          Primer_apellido: "Hernandez",
          Segundo_apellido: "López",
          Contrasenia: "********",
          Autorizacion: "No",
          Direccion: {
            Numero: "333",
            Calle: "Sycamore St",
            Barrio: "Barrio de Prueba",
            Ciudad: "Ciudad de Prueba"
          },
        },
        {
          Cliente_ID: 8,
          Telefono: "5555555555",
          Documento_tipo: "Cédula",
          Documento_numero: "555555555",
          Primer_nombre: "Sofia",
          Segundo_nombre: "Valentina",
          Primer_apellido: "García",
          Segundo_apellido: "Ramirez",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "444",
            Calle: "Birch St",
            Barrio: "Barrio de Ejemplo",
            Ciudad: "Ciudad de Ejemplo"
          },
        },
        {
          Cliente_ID: 9,
          Telefono: "6666666666",
          Documento_tipo: "Cédula",
          Documento_numero: "666666666",
          Primer_nombre: "Luis",
          Segundo_nombre: "Fernando",
          Primer_apellido: "Perez",
          Segundo_apellido: "Hernandez",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "555",
            Calle: "Aspen St",
            Barrio: "Barrio de Prueba",
            Ciudad: "Ciudad de Prueba"
          },
        },
        {
          Cliente_ID: 10,
          Telefono: "7777777777",
          Documento_tipo: "Cédula",
          Documento_numero: "777777777",
          Primer_nombre: "Ana",
          Segundo_nombre: "Maria",
          Primer_apellido: "Gómez",
          Segundo_apellido: "Ramirez",
          Contrasenia: "********",
          Autorizacion: "Si",
          Direccion: {
            Numero: "666",
            Calle: "Chestnut St",
            Barrio: "Barrio de Ejemplo",
            Ciudad: "Ciudad de Ejemplo"
          },
        },
        // Puedes agregar más usuarios aquí
      ],

      searchQuery: "",
      selectedUser: null, // Para almacenar el usuario seleccionado para mostrar en el modal
      showModal: false, // Para controlar la visibilidad del modal
      filteredUsers: [],
      searchTerm: "",
      modifyingUser: null,
      editingField: null,
      showModalUser: false,

    };
  },
  mounted() {
    this.searchUsers();
  },
  methods: {
    changeUserDetails(user, field) {
      this.modifyingUser = user;
      this.editingField = field;
      this.showModalUser = true
      console.log(this.showModalUser)
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

    saveUserChanges() {
      // Aquí debes realizar la lógica para guardar los cambios en el usuario en tu base de datos (usando PHP y MariaDB).
      // Puedes enviar una solicitud al servidor PHP para realizar la actualización de los datos.

      // Una vez que los cambios se hayan guardado exitosamente, cierra el modal y actualiza la lista de usuarios si es necesario.
      this.showModal = false;

      // Llamar a una función para actualizar la lista de usuarios si es necesario.
      this.updateUserList();
    },
    fetchUsers() {
      const dataToSend = {
        functionName: "admin_show_user_list",
        a: "",
        b: ''
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
          if (Array.isArray(response.data)) {
            this.users = response.data[0]
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    searchUsers() {
      this.closeModal();

      this.fetchUsers();

      const query = this.searchQuery.toLowerCase().trim();

      if (query === "") {
        this.filteredUsers = this.users;
        this.filteredUsers = this.users.map((user) => {
          return { ...user, showDetails: false };
        })
      } else {
        this.filteredUsers = this.users.filter((user) => {
          const idMatch = user.Cliente_ID.toString().includes(query);
          const telefonoMatch = user.Telefono.toString().includes(query);
          const tipoDocumentoMatch = user.Documento_tipo.toLowerCase().includes(query);
          const numeroDocumentoMatch = user.Documento_numero.toString().includes(query);
          const primerNombreMatch = user.Primer_nombre.toLowerCase().includes(query);
          const segundoNombreMatch = user.Segundo_nombre.toLowerCase().includes(query);
          const primerApellidoMatch = user.Primer_apellido.toLowerCase().includes(query);
          const segundoApellidoMatch = user.Segundo_apellido.toLowerCase().includes(query);

          return (
            idMatch ||
            telefonoMatch ||
            tipoDocumentoMatch ||
            numeroDocumentoMatch ||
            primerNombreMatch ||
            segundoNombreMatch ||
            primerApellidoMatch ||
            segundoApellidoMatch
          );
        });
        if (this.filteredUsers.length === 0) {
          this.filteredUsers = [];
        }
      }
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
  