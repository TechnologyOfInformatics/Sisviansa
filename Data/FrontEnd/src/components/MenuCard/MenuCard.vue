<template>
  <div>
    <div v-if="!custom" class="options-filter">
      <form class="form" @submit.prevent="searchMenu">
        <button>
          <svg width="17" height="16" fill="none" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="search">
            <path d="M7.667 12.667A5.333 5.333 0 107.667 2a5.333 5.333 0 000 10.667zM14.334 14l-2.9-2.9"
              stroke="currentColor" stroke-width="1.333" stroke-linecap="round" stroke-linejoin="round"></path>
          </svg>
        </button>
        <input class="input" placeholder="Busca tu menú" id="textSearch" required type="text" v-model="textSearch">
        <button class="reset" type="reset">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"
            stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </form>
      <button class="button-top" @click="openCustomModal" v-if="isAuthenticated">
        Menu Personalizado
      </button>
    </div>
    <div class="menu-list" v-if="!custom">
      <div v-for="menu in menus" :key="menu.id" class="menu-card">
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
              <button class="button-bottom" v-if="isAuthenticated && web">
                <i class="fa-solid fa-heart" :class="{ favorite: isFavorite(menu.id) }"
                  @click="toggleFavorite(menu.id)"></i>
              </button>
              <button class="button-bottom" @click="selectMenu(menu)">
                <i class="fa-solid fa-cart-plus"></i>
              </button>
            </div>
            <div class="footer-side-icons">
              <button class="button-side" v-if="showSinGlutenButton(menu)">
                <img src="../../assets/page-icons/nogluten-iso.png" alt="Sin Gluten">
              </button>
              <button class="button-side" v-if="showVeganoButton(menu)">
                <img src="../../assets/page-icons/vegan-iso.png" alt="Vegano">
              </button>
              <button class="button-side" v-if="showVegetarianoButton(menu)">
                <img src="../../assets/page-icons/vegetarian-iso.png" alt="Vegetariano">
              </button>
            </div>

          </div>
        </div>
      </div>
    </div>

    <div>
      <div v-if="favoriteMenus.length > 0 && custom" class="menu-list">
        <div v-for="menu in favoriteMenus" :key="menu.id" class="menu-card">
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
                <button class="button-bottom" v-if="isAuthenticated">
                  <i class="fa-solid fa-heart favorite"></i>
                </button>
                <button class="button-bottom" @click="selectMenu(menu)">
                  <i class="fa-solid fa-cart-plus"></i>
                </button>
              </div>
              <div class="footer-side-icons">
                <button class="button-side" v-if="showSinGlutenButton">
                  <img src="../../assets/page-icons/nogluten-iso.png" alt="Sin Gluten">
                </button>
                <button class="button-side" v-if="showVeganoButton">
                  <img src="../../assets/page-icons/vegan-iso.png" alt="Vegano">
                </button>
                <button class="button-side" v-if="showVegetarianoButton">
                  <img src="../../assets/page-icons/vegetarian-iso.png" alt="Vegetariano">
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else-if="custom">
        <div class="empty-favorites">
          <p>No tienes menus favoritos, si quieres puedes añadirlos en la <router-link to="/shop"
              class="link">Tienda</router-link> </p>
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
        <p class="price">Precio Total: {{ selectedMenu.price }} USD</p>

      </div>
      <div class="viandas">
        <h3>Viandas</h3>
        <ul>
          <li v-for="vianda in selectedMenu.viandas" :key="vianda.name">
            <span class="vianda-name">{{ vianda.name }}</span>
            <div class="vianda-details">
              <span class="diet">{{ vianda.diet }}</span>
              <span class="vianda-price">{{ vianda.precio }} USD</span>

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
  <div v-if="showCustomModal" class="modal" @click="closeCustomModal">
    <div class="modal-content modal-custom" @click.stop>
      <div v-if="customMenus.length > 0">
        <ul>
          <li v-for="customMenu in customMenus" :key="customMenu.id">
            <div>
              <h3>{{ customMenu.title }}</h3>
              <p>Descripción: {{ customMenu.description }}</p>
              <h4>Viandas:</h4>
              <ul class="modal-vianda">
                <li v-for="vianda in customMenu.viandas" :key="vianda.id">
                  <p>{{ vianda.name }}</p>
                  <p>Calorías: {{ vianda.calories }}</p>
                  <p>Dietas: {{ vianda.diets ? vianda.diets.join(', ') : 'Ninguna' }}</p>
                </li>
              </ul>
            </div>
            <button @click="addToCart(customMenu)" class="customButton">Añadir al carrito</button>
            <button @click="removeCustomMenu(customMenu.id)" class="customButton">Eliminar de personalizado</button>
          </li>
        </ul>
      </div>
      <div v-else class="empty-custom">
        <p>No tienes menues personalizados, puedes añadir uno con el botón.</p>
      </div>
      <button @click="modalCreateCustomMenu"> Crea un menú personalizado</button>

    </div>
  </div>
  <div v-if="modalCreateCustom" class="modal" @click="modalCreateCustomMenu">
    <div class="modal-content modal-custom" @click.stop>

      NO implementado.
    </div>
  </div>
</template>

<script>
export default {
  name: "MenuCard",
  props: {
    custom: Boolean,
  }, emits: ["updateCart"],
  data() {
    return {
      cart: [],
      favorites: [],
      showModal: false,
      selectedMenu: null,
      addedToCart: false,
      favoritesActions: [],
      menus: [],
      isAuthenticated: false,
      textSearch: "",
      showCustomModal: false,
      customMenus: [],
      web: false,
      modalCreateCustom: false,
      noDataValue: '',
    };
  },


  created() {
    this.fetchUserData()
    this.handleRouteLogic()
  },
  computed: {
    favoriteMenus() {
      return this.menus.filter(menu => this.isFavorite(menu.id));
    },

  },

  methods: {
    showSinGlutenButton(menu) {
      return menu.diets && menu.diets.includes('Sin Gluten')

    },
    showVeganoButton(menu) {
      return menu.diets && menu.diets.includes('Vegana')

    },
    showVegetarianoButton(menu) {
      return menu.diets && menu.diets.includes('Vegetariana')

    },
    modalCreateCustomMenu() {
      this.modalCreateCustom = !this.modalCreateCustom
    },

    openCustomModal() {
      this.showCustomModal = true;
    },
    closeCustomModal() {
      this.showCustomModal = false;
    },
    searchMenu() {
      const dataToSend = {
        functionName: "shop_show_shop",
        token: sessionStorage.getItem('miToken'),
        texto: this.textSearch,
        // ahora pasarle filtro y eso
      };

      this.$http
        .post("http://localhost:9000/server.php", dataToSend)
        .then((response) => {
          this.noDataValue = response.data

        })
        .catch((error) => {
          console.error(error);
        });
    },
    calculateTotalPrice(viandas) {
      let total = 0;
      for (const vianda of viandas) {
        total += parseFloat(vianda.precio);
      }
      return total.toFixed(2);
    },
    fetchCustomMenus() {
      const dataToSend = {
        functionName: "options_get_personal_menus",
        token: sessionStorage.getItem('miToken'),
      };
      this.$http
        .post("http://localhost:9000/server.php", dataToSend)
        .then((response) => {
          if (Array.isArray(response.data)) {
            if (response.data.length > 0) {
              this.customMenus = this.transformMenusData(response.data)

            }
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    removeCustomMenu(data) {

      const dataToSend = {
        functionName: "options_del_personal_menu",
        token: sessionStorage.getItem('miToken'),
        id: data
      };

      this.$http
        .post("http://localhost:9000/server.php", dataToSend)
        .then((response) => {
          if (Array.isArray(response.data)) {
            this.customMenus = response.data
          }

        })
        .catch((error) => {
          console.error(error);
        });
    },
    createCustomMenu() {
      const dataToSend = {
        functionName: "options_add_personal_menu",
        token: sessionStorage.getItem('miToken'),
        //        todo el menu
      };

      this.$http
        .post("http://localhost:9000/server.php", dataToSend)
        .then((response) => {
          this.noDataValue = response.data


        })
        .catch((error) => {
          console.error(error);
        });
    },

    transformMenusData(data) {

      return data.map((menuData) => {
        const viandas = [];
        let totalCalories = 0;

        if (Array.isArray(menuData.viandas)) {
          for (const viandaData of menuData.viandas) {
            const vianda = {
              id: viandaData.id,
              name: viandaData.nombre,
              calories: parseInt(viandaData.calorias),
            };

            if (viandaData.precio) {
              vianda.precio = parseFloat(viandaData.precio);
            }

            if (viandaData.dietas) {
              vianda.diets = viandaData.dietas;
            }

            viandas.push(vianda);
            totalCalories += parseInt(viandaData.calorias);
          }
        }

        return {
          id: parseInt(menuData.id),
          title: menuData.nombre,
          calories: totalCalories,
          frequency: parseInt(menuData.frecuencia),
          description: menuData.descripcion,
          price: this.calculateTotalPrice(viandas),
          viandas: viandas,
          diets: menuData.dietas
        };

      });
    },

    fetchUserData() {
      const dataToSend = {
        functionName: "shop_show_shop",
        token: sessionStorage.getItem('miToken'),
      };

      this.$http
        .post("http://localhost:9000/server.php", dataToSend)
        .then((response) => {
          this.menus = this.transformMenusData(response.data[0]);
          this.menus.forEach((menu) => {
            menu.isFavorite = false;
          });

          if (Array.isArray(response.data[1])) {
            this.isAuthenticated = true;
            const menuIds = response.data[1].map(menuId => parseInt(menuId, 10));
            this.favorites = menuIds;

            menuIds.forEach((menuId) => {
              const menu = this.menus.find((m) => m.id === menuId);
              if (menu) {
                menu.isFavorite = true;
              }
            });
            if (this.isAuthenticated) {
              this.fetchCustomMenus();
            }

          }

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
        functionName: "shop_favorites_toggle",
        token: sessionStorage.getItem('miToken'),
        favorite: action.id,
      };
      this.$http
        .post("http://localhost:9000/server.php", dataToSend)
        .then((response) => {
          this.noDataValue = response.data
        })
        .catch((error) => {
          console.error(error);
        });
    },
    validateUserData() {
      const token = sessionStorage.getItem("miToken") || "undefined";
      const dataToSend = {
        functionName: "base_session",
        token: token,
      };

      return this.$http.post("http://localhost:9000/server.php", dataToSend);
    },
    handleRouteLogic() {

      this.validateUserData()
        .then((response) => {
          if (response.data[0] == false) {
            this.web = true
          } else {
            this.web = false
          }

        })
        .catch((error) => {
          console.error(error);

        });
    },

  },
};
</script>

<style lang="css" src="./MenuCard.css" scoped></style>
