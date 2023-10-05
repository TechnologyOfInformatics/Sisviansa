<template>
  <div>
    <div class="menu-list">
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
              <button class="button-bottom">
                <i class="fa-solid fa-heart" :class="{ favorite: isFavorite(menu.id) }"
                  @click="toggleFavorite(menu.id)"></i>
              </button>
              <button class="button-bottom" @click="selectMenu(menu)">
                <i class="fa-solid fa-cart-plus"></i>
              </button>
            </div>
            <div class="footer-side-icons">
              <button class="button-side" v-if="menu.viandas.some(vianda => vianda.diets.includes('Sin Gluten'))">
                <img src="../../assets/page-icons/nogluten-iso.png" alt="Sin Gluten">
              </button>
              <button class="button-side" v-if="menu.viandas.some(vianda => vianda.diets.includes('Vegana'))">
                <img src="../../assets/page-icons/vegan-iso.png" alt="Vegana">
              </button>
              <button class="button-side" v-if="menu.viandas.some(vianda => vianda.diets.includes('Vegetariana'))">
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
  data() {
    return {
      cart: [],
      favorites: [],
      showModal: false,
      selectedMenu: null,
      addedToCart: false,
      favoritesActions: [],
      menus: []
    };
  },




  created() {

    this.fetchUserData();
  },
  methods: {
    transformMenusData(data) {
      return data.map((menuData) => {
        const viandas = [];
        let totalCalories = 0;

        for (const viandaName in menuData.viandas) {
          if (Object.prototype.hasOwnProperty.call(menuData.viandas, viandaName)) {
            const vianda = menuData.viandas[viandaName];
            viandas.push({
              id: vianda.id,
              name: vianda.nombre,
              calories: parseInt(vianda.calorias),
              diets: vianda.dietas,
            });
            totalCalories += parseInt(vianda.calorias);
          }
        }

        return {
          id: parseInt(menuData.id),
          title: menuData.nombre,
          calories: totalCalories,
          frequency: parseInt(menuData.frecuencia),
          description: menuData.descripcion,
          price: parseFloat(menuData.precio),
          viandas: viandas,
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
          console.log(response.data)
          this.menus = this.transformMenusData(response.data[0]);
          this.menus.forEach((menu) => {
            menu.isFavorite = false;
          });

          if (Array.isArray(response.data[1])) {
            const menuIds = response.data[1].map(menuId => parseInt(menuId, 10));
            this.favorites = menuIds;

            menuIds.forEach((menuId) => {
              const menu = this.menus.find((m) => m.id === menuId);
              if (menu) {
                menu.isFavorite = true;
                console.log(menu.id, menu.isFavorite);
              }
            });
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
        functionName: "favorites_toggle",
        token: sessionStorage.getItem('miToken'),
        favorite: action.id,
      };
      console.log(action)
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
