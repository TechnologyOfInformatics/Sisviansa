<template>
  <div>
    <div class="menu-list">
      <div v-for="menu in menus" :key="menu.title" class="menu-card">
        <div class="menu-top">
          <img :src="getImgUrl(menu.image)" alt="Menu Image" />
          <div class="menu-top-text">
            <h2>{{ menu.title }}</h2>
            <p>{{ menu.type }}</p>
          </div>
        </div>
        <hr />
        <div class="menu-footer">
          <p class="description">
            {{ truncatedDescription(menu.description) }}
          </p>
          <div class="menu-footer-buttons">
            <div>
              <button @click="openModal(menu)" class="viewMore">
                <i class="fa-solid fa-circle-chevron-down"></i>
              </button>
            </div>
            <div class="footer-buttons-icons">
              <i
                class="fa-solid fa-heart"
                :class="{ favorite: isFavorite(menu.id) }"
                @click="toggleFavorite(menu.id)"
              ></i>
              <button class="add-to-cart-btn" @click="selectMenu(menu)">
                <i class="fa-solid fa-cart-plus"></i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <transition name="fade" mode="out-in">
      <div v-if="addedToCart" class="added-to-cart-message">
        <div><p>¡Se ha agregado al carrito!</p></div>
      </div>
    </transition>
    <div v-if="showModal" class="modal" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="menu-details">
          <h2>{{ selectedMenu.title }}</h2>
          <p>{{ selectedMenu.description }}</p>
          <img :src="getImgUrl(selectedMenu.image)" alt="Menu Image" />
          <p class="price">Precio: {{ selectedMenu.price }} USD</p>
        </div>
        <div class="viandas">
          <h3>Viandas</h3>
          <ul>
            <li v-for="vianda in selectedMenu.viandas" :key="vianda.name">
              <span class="vianda-name">{{ vianda.name }}</span>
              <div class="vianda-details">
                <span class="calories">{{ vianda.calories }} calorías</span>
                <span class="type">{{ vianda.type }}</span>
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
      menus: [
        {
          id: 1,
          title: "Menú 1",
          description:
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Ex placeat alias eos, blanditiis temporibus excepturi Lorem ipsum dolor sit, amet consectetur adipisicing elit. Laborum error ex ratione porro animi nobis. Adipisci incidunt culpa rem dolor odio ratione alias sequi vel libero itaque, quis corporis inventore? ",
          image: "bussiness-banner",
          price: 10,
          type: "Standar",
          viandas: [
            {
              name: "Vianda 1.1",
              calories: 300,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.2",
              calories: 250,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.3",
              calories: 200,
              type: "Vegetariana",
            },
          ],
        },
        {
          id: 2,
          title: "Menú 2",
          description: "Descripción del Menú 2",
          image: "bussiness-banner",
          price: 10,
          viandas: [
            {
              name: "Vianda 1.1",
              calories: 300,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.2",
              calories: 250,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.3",
              calories: 200,
              type: "Vegetariana",
            },
          ],
        },
        {
          id: 3,
          title: "Menú 1",
          description: "Descripción del Menú 1",
          image: "bussiness-banner",
          price: 10,
          viandas: [
            {
              name: "Vianda 1.1",
              calories: 300,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.2",
              calories: 250,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.3",
              calories: 200,
              type: "Vegetariana",
            },
          ],
        },
        {
          id: 4,
          title: "Menú 1",
          description: "Descripción del Menú 1",
          image: "bussiness-banner",
          price: 10,
          viandas: [
            {
              name: "Vianda 1.1",
              calories: 300,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.2",
              calories: 250,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.3",
              calories: 200,
              type: "Vegetariana",
            },
          ],
        },
        {
          id: 5,
          title: "Menú 5",
          description: "Descripción del Menú 1",
          image: "bussiness-banner",
          price: 10,
          viandas: [
            {
              name: "Vianda 1.1",
              calories: 300,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.2",
              calories: 250,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.3",
              calories: 200,
              type: "Vegetariana",
            },
          ],
        },
        {
          id: 6,
          title: "Menú 1",
          description: "Descripción del Menú 1",
          image: "bussiness-banner",
          price: 10,
          viandas: [
            {
              name: "Vianda 1.1",
              calories: 300,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.2",
              calories: 250,
              type: "Vegetariana",
            },
            {
              name: "Vianda 1.3",
              calories: 200,
              type: "Vegetariana",
            },
          ],
        },
      ],
      showModal: false,
      selectedMenu: null,
      addedToCart: false,
    };
  },
  methods: {
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
      const maxLength = 110;
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
        this.favorites.push(menuId); // Agrego a la lista de favoritos
      } else {
        const index = this.favorites.indexOf(menuId);
        if (index > -1) {
          this.favorites.splice(index, 1); // saco la lista de favoritos
        }
      }
    },
    toggleFavorite(menuId) {
      const isFavorite = this.isFavorite(menuId);
      this.setFavorite(menuId, !isFavorite);
    },
  },
};
</script>

<style lang="css" src="./MenuCard.css"></style>
