<template>
  <div>
    <div class="menu-list">
      <div v-for="menu in menuItems" :key="menu.title" class="menu-card">
        <div class="menu-top">
          <div class="menu-top-text">
            <div>
              <p class="menu-top-text-description">{{ menu.title }}</p>
            </div>
          </div>
        </div>
        <hr />
        <div class="menu-footer">
          <div class="description">
            <p>{{ truncatedDescription(menu.description) }}</p>
          </div>
          <div class="menu-footer-buttons">
            <div class="footer-bottom-icons">
              <button @click="openModal(menu)" class="viewMore button-bottom">
                <i class="fa-solid fa-circle-chevron-down"></i>
              </button>
              <button class="button-bottom">
                <i class="fa-solid fa-heart" :class="{ favorite: isFavorite(menu.id) }"
                  @click="toggleFavorite(menu.id)"></i>
              </button>
              <button class="button-bottom" @click="selectMenu(menu)">
                <i class="fa-solid fa-cart-plus"></i>
              </button>
            </div>
            <div class="footer-side-icons">
              <button class="button-side" v-if="this.menu.viandas.dieta.includes('Sin Gluten')">
                <img src="../../assets/page-icons/nogluten-iso.png" alt="Sin Gluten">
              </button>
              <button class="button-side" v-if="this.menu.viandas.dieta.includes('Vegana')">
                <img src="../../assets/page-icons/vegan-iso.png" alt="Vegana">
              </button>
              <button class="button-side" v-if="this.menu.viandas.dieta.includes('Vegetariana')">
                <img src="../../assets/page-icons/vegetarian-iso.png" alt="Vegetariana">
              </button>
            </div>

          </div>
        </div>
      </div>
    </div>
    <transition name="fade" mode="out-in">
      <div v-if="addedToCart" class="added-to-cart-message">
        <div>
          <p>¡Se ha agregado al carrito!</p>
        </div>
      </div>
    </transition>
    <div v-if="showModal" class="modal" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="menu-details">
          <h2>{{ selectedMenu.title }}</h2>
          <p>{{ selectedMenu.description }}</p>
          <p class="price">Precio: {{ selectedMenu.price }} USD</p>
        </div>
        <div class="viandas">
          <h3>Viandas</h3>
          <ul>
            <li v-for="vianda in selectedMenu.viandas" :key="vianda.name">
              <span class="vianda-name">{{ vianda.name }}</span>
              <div class="vianda-details">
                <span class="diet">{{ vianda.diet }}</span>
                <span class="calories">{{ vianda.calories }} calorías</span>
              </div>
            </li>
          </ul>

        </div>
        <div class="buttons">
          <button class="add-to-cart-btn" @click="addToCart(selectedMenu)">
            Añadir al carrito
          </button>
          <button class="close-btn" @click="closeModal">
            <i class="fa-solid fa-circle-xmark"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "MenuCard",
  props: {
    filterType: String,
    menuItems: Array,
  },
  data() {
    return {
      cart: [],
      favorites: [],
      showModal: false,
      selectedMenu: null,
      addedToCart: false,
      favoritesActions: [],
    };
  },
  computed: {
    sortedAndFilteredMenus() {
      // Ordena los elementos según la propiedad seleccionada en selectedCategory
      let sortedMenus = [...this.menuItems];
      if (this.selectedCategory === "Mayor Calorías") {
        sortedMenus.sort((a, b) => b.calories - a.calories);
      } else if (this.selectedCategory === "Menor Calorías") {
        sortedMenus.sort((a, b) => a.calories - b.calories);
      } else if (this.selectedCategory === "Mayor Precio") {
        sortedMenus.sort((a, b) => b.price - a.price);
      } else if (this.selectedCategory === "Menor Precio") {
        sortedMenus.sort((a, b) => a.price - b.price);
      }

      // Filtra los elementos según la propiedad seleccionada en selectedMenuType
      if (this.selectedMenuType === "Todos") {
        return sortedMenus;
      } else {
        return sortedMenus.filter((menu) =>
          menu.viandas.some((vianda) => vianda.diet === this.selectedMenuType)
        );
      }
    },
  },

  created() {
    this.fetchUserData();
  },
  methods: {
    transformMenusData(data) {
      return data.map((menuData) => {
        // Inicializamos contadores para cada tipo de dieta
        let vegetarianCount = 0;
        let veganCount = 0;
        let glutenFreeCount = 0;

        const viandas = menuData.Viandas.map((vianda) => {
          // Asumimos que vianda tiene un arreglo de dietas
          const dietas = vianda.Dietas.map((dieta) => dieta);

          // Contamos las dietas en esta vianda
          if (dietas.includes("Vegetariana")) {
            vegetarianCount++;
          }
          if (dietas.includes("Vegana")) {
            veganCount++;
          }
          if (dietas.includes("Sin Gluten")) {
            glutenFreeCount++;
          }

          return {
            id: vianda.ID,
            name: vianda.Nombre,
            calories: vianda.Calorias,
            dietas,
          };
        });

        // Determinamos la dieta predominante del menú
        let predominantDiet = "Todos"; // Valor por defecto

        if (vegetarianCount === viandas.length) {
          predominantDiet = "Vegetariana";
        } else if (veganCount === viandas.length) {
          predominantDiet = "Vegana";
        } else if (glutenFreeCount === viandas.length) {
          predominantDiet = "Sin Gluten";
        }

        return {
          id: parseInt(menuData.ID),
          title: menuData.Nombre,
          calories: parseInt(menuData.Calorias),
          frequency: parseInt(menuData.Frecuencia),
          description: menuData.Descripcion,
          price: parseInt(menuData.Precio),
          viandas: viandas,
          predominantDiet: predominantDiet, // Agregamos la dieta predominante
        };
      });
    },

    fetchUserData() {
      const dataToSend = {
        functionName: "shop_show_shop",
        token: sessionStorage.getItem('miToken'),
      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          this.menus = this.transformMenusData(response.data[0]);
          this.favorites = response.data[1];
          console.log()

        })
        .catch((error) => {
          console.error(error);
        });
    },
    openModal(menu) {
      this.selectedMenu = menu;
      this.showModal = true;
    },
    closeModal() {
      this.selectedMenu = null;
      this.showModal = false;
    },
    addToCart(menu) {
      if (menu && menu.id) {
        const existingItem = this.cart.find((item) => item.id === menu.id);
        if (existingItem) {
          existingItem.quantity++;
        } else {
          const newItem = {
            ...menu,
            quantity: 1,
          };
          this.cart.push(newItem);
        }
        this.$emit("update-cart", this.cart);
        this.showAddedToCartMessage();
      }
    },

    showAddedToCartMessage() {
      this.addedToCart = true;
      setTimeout(() => {
        this.addedToCart = false;
      }, 900);
    },
    selectMenu(menu) {
      this.selectedMenu = menu;
      this.addToCart(menu);
    },
    getImgUrl(image) {
      return require(`@/assets/imgs/${image}.png`);
    },
    truncatedDescription(description) {
      const maxLength = 70;
      if (description.length > maxLength) {
        return `${description.substring(0, maxLength)}...`;
      }
      return description;
    },
    isFavorite(menuId) {
      return this.favorites.includes(menuId);
    },

    setFavorite(menuId, isFavorite) {
      if (isFavorite) {
        this.favorites.push(menuId);
      } else {
        const index = this.favorites.indexOf(menuId);
        if (index > -1) {
          this.favorites.splice(index, 1);
        }
      }
    },
    toggleFavorite(menuId) {
      const isFavorite = this.isFavorite(menuId);

      if (isFavorite) {
        this.setFavorite(menuId, false);
        this.favoritesActions.push({ action: "remove", id: menuId });
      } else {
        this.setFavorite(menuId, true);
        this.favoritesActions.push({ action: "add", id: menuId });
      }

      const lastAction = this.favoritesActions[this.favoritesActions.length - 1];
      this.updateFavoritesOnServer(lastAction);
    },

    lastFavorite() {
      return this.favorites[this.favorites.length - 1];
    },
    updateFavoritesOnServer(action) {
      const dataToSend = {
        functionName: "updateFavorites",
        token: sessionStorage.getItem('miToken'),
        favorite: action,
      };
      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
        })
        .catch((error) => {
          console.error(error);
        });
    }

  },
};
</script>

<style lang="css" src="./MenuCard.css" scoped></style>
