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
            <li><a @click="showCategory('menu')" class="aside-link">Menu</a></li>
            <li><a @click="showCategory('food')" class="aside-link">Vianda</a></li>
            <li><a @click="showCategory('mod')" class="aside-link">a</a></li>
          </ul>
        </nav>
        <footer class="sidebar__footer">Sisviansa</footer>
      </aside>
      <section class="main__section">
        <div v-if="currentCategory === 'menu'" class="category-content">
        </div>
        <div v-if="currentCategory === 'food'" class="category-content">
        </div>
        <div v-if="currentCategory === 'mod'" class="category-content">
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
    }
  },

  methods: {

    showCategory(category) {
      this.currentCategory = category;
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
</style>
  