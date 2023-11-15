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
            <li><a @click="showCategory('menu')" class="aside-link">Listado de Menus</a></li>
            <li><a @click="showCategory('food')" class="aside-link">Listado de Viandas</a></li>
            <li><a @click="showCategory('createM')" class="aside-link">Crear Menu</a></li>
            <li><a @click="showCategory('createF')" class="aside-link">Crear Vianda</a></li>
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


                </tr>
              </tbody>
            </div>
          </table>
        </div>
        <div v-if="currentCategory === 'createM'" class="category-content">
          <form @submit.prevent="createMenu">

            <h1>Crear un menu</h1>
            <input v-model="menuName" type="text" id="menuName" placeholder="Nombre del menú" required>

            <input v-model="menuFrequency" type="text" id="menuFrequency" placeholder="Frecuencia del menú" required>

            <input v-model="menuDescription" id="menuDescription" placeholder="Descripción del menú" required>

            <label for="menuFoods">Viandas del menú:</label>
            <select v-model="selectedVianda" id="menuFoods">
              <option v-for="vianda in menuFoods" :key="vianda">{{ vianda }}</option>
            </select>
            <button @click.prevent="addVianda">Añadir Vianda</button>


            <div v-if="errorMessage" class="error-message">
              {{ errorMessage }}
            </div>
            <div v-if="succesMessage" class="succes-message">
              {{ succesMessage }}
            </div>

            <button type="submit">Guardar Menu</button>

          </form>

        </div>

        <div v-if="currentCategory === 'createF'" class="category-content">
          <form @submit.prevent="createFood">

            <h1>Crear una vianda</h1>
            <input v-model="viandaName" type="text" id="viandaName" placeholder="Nombre de la vianda" required>

            <input v-model="viandaTiempo" type="text" id="viandaTiempo" placeholder="Tiempo de coccion de la vianda"
              required>

            <input v-model="viandaProducts" id="viandaProducts" placeholder="Productos de la vianda" required>

            <input v-model="viandaCalorias" type="number" id="viandaCalorias" placeholder="Calorías de la vianda"
              required>
            <input v-model="viandaPrice" type="number" id="viandaPrice" placeholder="Precio de la vianda" required>

            <div v-if="errorMessage" class="error-message">
              {{ errorMessage }}
            </div>
            <div v-if="succesMessage" class="succes-message">
              {{ succesMessage }}
            </div>

            <button type="submit">Guardar Vianda</button>

          </form>

        </div>
      </section>

    </main>
  </div>
</template>
  
  
<script>
export default {
  data() {
    return {
      currentCategory: null,
      username: "Nombre de Usuario",
      menus: [],
      foods: [],
      searchQuery: "",
      selectedUser: null, // Para almacenar el usuario seleccionado para mostrar en el modal
      showModal: false, // Para controlar la visibilidad del modal
      filteredMenus: [],
      filteredFoods: [],
      searchTerm: "",
      showModalUser: false,
      errorMessage: '',
      succesMessage: '',
      menuName: '',
      menuFrequency: '',
      menuDescription: '',
      menuFoods: [],
      viandaName: '',
      viandaTiempo: '',
      viandaProducts: '',
      viandaCalorias: '',
      viandaPrice: ''

    };
  },
  mounted() {
    this.fetchViandas();

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
    fetchViandas() {

      const dataToSend = {
        functionName: "admin_get_foods",

      };
      this.$http
        .post("http://sisviansa_php/server.php", dataToSend)
        .then((response) => {
          this.foods = response.data;
          console.log(this.foods)
          this.searchFoods()
        })
        .catch((error) => {
          console.error(error);
        });
    },

    searchFoods() {

      const query = this.searchQuery.toLowerCase().trim();

      if (query === "") {
        this.filteredFoods = this.foods;
        this.filteredFoods = this.foods.map((food) => {
          return { ...food };
        })
      } else {
        this.filteredFoods = this.foods.filter((food) => {
          const nombreMatch = food.nombre.toString().includes(query);


          return (
            nombreMatch

          );
        });
        if (this.filteredFoods.length === 0) {
          this.filteredFoods = [];
        }
      }
    },

    createMenu() {

      const dataToSend = {
        functionName: "admin_create_menu",
        name: this.menuName,
        doc: this.menuFrequency,
        mail: this.menuDescription,
        passwd: this.menuFoods,
      };

      this.$http
        .post("http://sisviansa_php/server.php", dataToSend)
        .then((response) => {
          if (response.data == "Error 404") {
            this.errorMessage = 'Error creando el menu'
          } else {
            this.succesMessage = "Menu creado"
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },

    createFood() {

      const dataToSend = {
        functionName: "admin_create_food",
        name: this.viandaName,
        tiempo: this.viandaTiempo,
        product: this.viandaProducts,
        calorias: this.viandaCalorias,
        price: this.viandaPrice
      };

      this.$http
        .post("http://sisviansa_php/server.php", dataToSend)
        .then((response) => {
          if (response.data == "Error 404") {
            this.errorMessage = 'Error creando el menu'
          } else {
            this.succesMessage = "Menu creado"
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
  