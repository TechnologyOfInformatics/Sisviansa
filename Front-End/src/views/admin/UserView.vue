<template>
    <div class="container">
      <header class="header">
        <nav class="header__nav">
          <div class="header__logo">
            <h2>Sisviansa</h2>
          </div>
          <div class="header__user-info">
            <span>Welcome, {{ username }}</span>
          </div>
        </nav>
      </header>
      <main class="main">
        <aside class="sidebar">
          <nav class="sidebar__nav">
            <ul class="sidebar__list">
              <li><a href="#" @click="showCategory('orders')">Orders</a></li>
              <li><a href="#" @click="showCategory('users')">Users</a></li>
              <li><a href="#" @click="showCategory('admin')">Admin</a></li>
            </ul>
          </nav>
          <footer class="sidebar__footer">Sisviansa</footer>
        </aside>
        <section class="main__section">
          <div v-if="currentCategory === 'users'" class="category-content">
            <h1 class="category-content__title">User Information</h1>
            <table class="user-table">
              <thead>
                <tr>
                  <th>Cliente ID</th>
                  <th>Teléfono</th>
                  <th>Documento Tipo</th>
                  <th>Documento Número</th>
                  <th>Primer Nombre</th>
                  <th>Segundo Nombre</th>
                  <th>Primer Apellido</th>
                  <th>Segundo Apellido</th>
                  <th>Contraseña</th>
                  <th>Autorización</th>
                  <th>Dirección</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in users" :key="user.Cliente_ID">
                  <td>{{ user.Cliente_ID }}</td>
                  <td>{{ user.Telefono }}</td>
                  <td>{{ user.Documento_tipo }}</td>
                  <td>{{ user.Documento_numero }}</td>
                  <td>{{ user.Primer_nombre }}</td>
                  <td>{{ user.Segundo_nombre }}</td>
                  <td>{{ user.Primer_apellido }}</td>
                  <td>{{ user.Segundo_apellido }}</td>
                  <td>{{ user.Contrasenia }}</td>
                  <td>{{ user.Autorizacion }}</td>
                  <td>
                    <button @click="showUserDetails(user)">+</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
        <!-- Modal para mostrar detalles del usuario -->
        <div v-if="showModal" class="modal">
          <div class="modal-content">
            <span class="close" @click="closeModal">&times;</span>
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
                <tr>
                  <td>Dirección:</td>
                  <td>
                    {{ selectedUser.Direccion.Numero }},
                    {{ selectedUser.Direccion.Calle }},
                    {{ selectedUser.Direccion.Barrio }},
                    {{ selectedUser.Direccion.Ciudad }}
                  </td>
                </tr>
                <!-- Agrega más detalles del usuario aquí -->
              </tbody>
            </table>
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
                    Contrasenia: "********",
                    Autorizacion: "Si",
                    Direccion: {
                        Numero: "123",
                        Calle: "Main St",
                        Barrio: "Barrio Ejemplo",
                        Ciudad: "Ciudad Ejemplo"
                    },
                }
                // Puedes agregar más usuarios aquí
            ],
            selectedUser: null, // Para almacenar el usuario seleccionado para mostrar en el modal
            showModal: false, // Para controlar la visibilidad del modal
        };
    },

    methods: {
        showCategory(category) {
            this.currentCategory = category;
        },
        showUserDetails(user) {
            this.selectedUser = user;
            this.showModal = true;
        },
        closeModal() {
            this.showModal = false;
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

.container {
    display: flex;
    flex-direction: column;
    height: 90vh;
}

.header {
    background: linear-gradient(112.1deg, rgb(32, 38, 57) 11.4%, rgb(63, 76, 119) 70.2%);
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

.sidebar {
    width: 20%;
    height: 86.5vh;
    background: linear-gradient(175deg, rgb(32, 38, 57) 0%, rgb(63, 76, 119) 50%, rgb(32, 38, 57) 100%);
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

.main {
    flex-grow: 1;
    display: flex;
}

.main__section {
    margin: 1vw;
    flex-grow: 1;
    padding: 20px;
    background: linear-gradient(112.1deg, rgb(32, 38, 57) 11.4%, rgb(63, 76, 119) 70.2%);
    height: 83.9vh;
    border-radius: 15px;
}

.category-content__title {
    font-size: 24px;
    margin-bottom: 10px;
}

.category-content__article {
    font-size: 16px;
    line-height: 1.5;
}
/* Estilos para la tabla de usuarios */
.user-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
}

.user-table th,
.user-table td {
  padding: 10px;
  text-align: center;
  border: 1px solid #ddd;
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

.user-details-table td {
  padding: 10px;
  text-align: left;
  border: 1px solid #ddd;
}

.user-details-table tr:nth-child(even) {
  background-color: #f8f8f8;
}

</style>
  