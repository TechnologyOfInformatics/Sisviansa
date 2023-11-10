<template>
  <MainHeader />
  <div class="container">
    <div class="data">
      <div class="data-card">
        <form @submit.prevent="addCardUser" v-if="showAddCardModal || cards.length === 0">
          <div class="row">
            <div class="col">

              <h3 class="title">Agrega una tarjeta</h3>
              <div class="inputBox">
                <span>Nombre en Tarjeta</span>
                <input type="text" placeholder="Jorge Rodriguez" v-model="cardData.cardholderName">
              </div>
              <div class="inputBox">
                <span>Número de Tarjeta</span>
                <input type="text" placeholder="1234 5678 9000 1234" v-model="cardData.cardNumber" maxlength="16"
                  @input="validateNumericInput('cardNumber')">
                <div v-if="!isNumericInputValid.cardNumber && cardData.cardNumber" class="error-message">
                  Ingresa solo números.
                </div>
              </div>
              <div class="inputBox">
                <span>Mes de Vencimiento</span>
                <input type="text" placeholder="03" v-model="cardData.expirationMonth" maxlength="2"
                  @input="validateNumericInput('expirationMonth')">
                <div v-if="!isNumericInputValid.expirationMonth && cardData.expirationMonth" class="error-message">
                  Ingresa solo números.
                </div>
              </div>
              <div class="inputBox">
                <span>Año de Vencimiento :</span>
                <input type="text" placeholder="2024" v-model="cardData.expirationYear" maxlength="4"
                  @input="validateNumericInput('expirationYear')">
                <div v-if="!isNumericInputValid.expirationYear && cardData.expirationYear" class="error-message">
                  Ingresa solo números.
                </div>

              </div>
              <div class="inputBox">
                <span>CVV :</span>

                <input type="text" placeholder="420" v-model="cardData.cvv" maxlength="4"
                  @input="validateNumericInput('ccv')">
                <div v-if="!isNumericInputValid.ccv && cardData.ccv" class="error-message">
                  Ingresa solo números.
                </div>
              </div>

            </div>
            <div class="col">
              <div class="card">
                <div class="card__front card__part">
                  <img class="card__front-square card__square" src="../../assets//page-icons/card-chip.png">
                  <img class="card__front-logo card__logo" src="../../assets/page-icons/contact-less.png">
                  <p class="card_numer">
                    <span> {{ formattedCardNumber }}</span>
                  </p>
                  <div class="card__space-75">
                    <span class="card__label">Nombre en Tarjeta</span>
                    <p class="card__info">{{ cardData.cardholderName || 'Jorge Rodriguez' }}</p>
                  </div>
                  <div class="card__space-25">
                    <span class="card__label">Expiración</span>
                    <div class="card__info">
                      <p>{{ cardData.expirationMonth || '03' }}{{ '/' }}{{ cardData.expirationYear || '2024' }}</p>

                    </div>
                  </div>
                </div>

                <div class="card__back card__part">
                  <div class="card__black-line"></div>
                  <div class="card__back-content">
                    <div class="card__secret">
                      <p class="card__secret--last">{{ cardData.cvv || '420' }}</p>
                    </div>

                    <div class="card-back-tex">
                      <p class="card-back-text">This card is the property of the issuing institution. Misuse is a criminal
                        offense. If found, please
                        return to the issuing institution or to the nearest bank that accepts cards with the same card
                        network
                        logo.</p>
                      <p class="card-back-text"> Use of this card is subject to the credit card agreement
                      </p>
                    </div>
                  </div>
                </div>

              </div>
            </div>
          </div>

          <input type="submit" value="Add tarjeta" class="submit-btn">

        </form>
        <div v-else>
          <div class="carousel">
            <button class="next-button">
              <i class="fas fa-chevron-left" @click="prevCard" v-if="cards.length > 1"></i>
            </button>
            <div class="cards">
              <transition name="fade" mode="out-in">
                <div :key="currentIndex" class="card">
                  <div class="card__front card__part">
                    <img class="card__front-square card__square" src="../../assets//page-icons/card-chip.png">
                    <img class="card__front-logo card__logo" src="../../assets/page-icons/contact-less.png">
                    <p class="card_numer">
                      <span> **** **** **** {{ cards[currentIndex].digitos_verificadores }}</span>
                    </p>
                    <div class="card__space-75">
                      <span class="card__label">Nombre en Tarjeta</span>
                      <p class="card__info">{{ cards[currentIndex].nombre_de_titular || 'Jorge Rodriguez' }}</p>
                    </div>
                    <div class="card__space-25">
                      <span class="card__label">Expiración</span>
                      <div class="card__info">
                        <p>{{ cards[currentIndex].fecha_de_vencimiento }}</p>
                      </div>
                    </div>
                  </div>

                  <div class="card__back card__part">
                    <div class="card__black-line"></div>
                    <div class="card__back-content">
                      <div class="card__secret">
                        <p class="card__secret--last">***</p>
                      </div>

                      <div class="card-back-text-cont">
                        <p class="card-back-text">This card is the property of the issuing institution. Misuse is a
                          criminal
                          offense. If found, please
                          return to the issuing institution or to the nearest bank that accepts cards with the same card
                          network
                          logo.</p>
                        <p class="card-back-text"> Use of this card is subject to the credit card agreement
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </transition>
            </div>
            <button class="next-button">
              <i class="fas fa-chevron-right" @click="nextCard" v-if="cards.length > 1"></i>
            </button>
          </div>
          <button type="button" class="button" @click="showAddCardModal = true">
            <span class="button__text">Agregar Tarjeta</span>
            <span class="button__icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" viewBox="0 0 24 24"
                stroke-width="2" stroke-linejoin="round" stroke-linecap="round" stroke="currentColor" height="24"
                fill="none" class="svg">
                <line y2="19" y1="5" x2="12" x1="12"></line>
                <line y2="12" y1="12" x2="19" x1="5"></line>
              </svg></span>
          </button>

        </div>
      </div>
    </div>
    <div class="cart">
      <h2>Carrito de Compras</h2>
      <div v-if="cart.length === 0">Tu carrito está vacío.</div>
      <div v-else>
        <div v-for="(item, index) in cart" :key="index" class="cart-item">
          <div class="item-details">
            <h3>{{ item.title }}</h3>
            <p>Precio: ${{ item.price }}</p>
            <p>Calorías: {{ item.calories }}</p>
            <p>Descripción: {{ item.description }}</p>
            <div>
              Cantidad:
              <button @click="decrementQuantity(item)" :disabled="item.quantity === 1">-</button>
              {{ item.quantity }}
              <button @click="incrementQuantity(item)">+</button>
            </div>
            <button @click="removeFromCart(item)">Eliminar</button>
          </div>
        </div>
        <div class="cart-summary">
          <p>Total: ${{ calculateTotalPrice() }}</p>
          <button class="button-checkout" @click="checkout">Completar Compra</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import MainHeader from '@/components/Header/Header.vue'
export default {
  components: {
    MainHeader,
  },
  data() {
    return {
      login: true,
      cart: [],
      cards: [],
      showAddCardModal: false,
      cardData: {
        cardholderName: "",
        cardNumber: "",
        expirationMonth: "",
        expirationYear: "",
        cvv: "",
      },
      isNumericInputValid: {
        expirationMonth: true,
        expirationYear: true,
        cardNumber: true,
        ccv: true,
      },
      currentDate: new Date(),
      currentIndex: 0,

    };
  },
  created() {
    const cartString = sessionStorage.getItem("cart");
    if (cartString) {
      this.cart = JSON.parse(cartString);
    }
    this.fetchCardUser()
  },
  computed: {
    formattedCardNumber() {
      const cardNumber = this.cardData.cardNumber.toString();
      if (typeof cardNumber === 'string') {
        const cleanValue = cardNumber.replace(/-/g, '');
        const formattedValue = cleanValue.match(/.{1,4}/g);
        if (formattedValue) {
          return formattedValue.join('-');
        }
      } return '1234-5678-9000-1234';
    }
  },
  methods: {
    nextCard() {
      if (this.currentIndex < this.cards.length - 1) {
        this.currentIndex++;
      } else {
        this.currentIndex = 0;
      }
    },
    prevCard() {
      if (this.currentIndex > 0) {
        this.currentIndex--;
      } else {
        this.currentIndex = this.cards.length - 1;
      }
    },
    validateNumericInput(fieldName) {
      const value = this.cardData[fieldName];
      const isValid = /^[0-9]*$/.test(value);
      this.isNumericInputValid[fieldName] = isValid;
    },
    validateExpirationDate() {
      const currentYear = this.currentDate.getFullYear();
      const expirationYear = parseInt(this.cardData.expirationYear);
      const expirationMonth = parseInt(this.cardData.expirationMonth);

      const isYearValid = expirationYear > currentYear;
      const isMonthValid = expirationMonth >= 1 && expirationMonth <= 12;

      return isYearValid && isMonthValid;
    },

    calculateTotalPrice() {
      let totalPrice = 0;
      for (const item of this.cart) {
        totalPrice += item.price * item.quantity;
      }
      return totalPrice.toFixed(2);
    },

    incrementQuantity(item) {
      item.quantity++;
      this.updateCart();
    },
    decrementQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
        this.updateCart();
      }
    },
    removeFromCart(item) {
      const index = this.cart.indexOf(item);
      if (index !== -1) {
        this.cart.splice(index, 1);
        this.updateCart();
      }
    },

    fetchCardUser() {
      const dataToSend = {
        functionName: "options_get_credit_card",
        token: sessionStorage.getItem('miToken') || 0,

      };

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
          this.cards = response.data

        })
        .catch((error) => {
          console.error(error);
        });
    },
    addCardUser() {
      const dataToSend = {
        functionName: "options_create_credit_card",
        token: sessionStorage.getItem('miToken') || 0,
        card_code: this.cardData.cardNumber,
        card_expire: this.cardData.expirationMonth + '/' + this.cardData.expirationYear,
        card_name: this.cardData.cardholderName,

      };
      console.log(dataToSend)

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
          this.showAddCardModal = false;
          this.fetchCardUser();
        })
        .catch((error) => {
          console.error(error);
        });
    },
    checkout() {
      if (this.cart.length === 0) {
        return;
      }
      const dataToSend = {
        functionName: "shop_buy_menu",
        token: sessionStorage.getItem('miToken') || 0,
        quantities: this.cart.map(item => item.quantity),
        menuIds: this.cart.map(item => item.id),
      };
      console.log(dataToSend)

      this.$http
        .post("http://localhost/Back-End/server.php", dataToSend)
        .then((response) => {
          console.log(response.data)
          this.cart = [];
          this.updateCart();

        })
        .catch((error) => {
          console.error(error);
        });
    },
    updateCart() {
      const cartString = JSON.stringify(this.cart);
      sessionStorage.setItem("cart", cartString);
    },
    selectOption(option) {
      this.selectedOption = option;
    },

    validateUserData() {
      const token = sessionStorage.getItem("miToken") || "undefined";
      const dataToSend = {
        functionName: "base_session",
        token: token,
      };

      return this.$http.post("http://localhost/Back-End/server.php", dataToSend);
    },
    handleRouteLogic() {

      this.validateUserData()
        .then((response) => {

          if (this.login) {
            if (!Array.isArray(response.data)) {
              this.$router.push("/login");

            }
          }
        })
        .catch((error) => {
          console.error(error);

        });
    },
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.handleRouteLogic();
    });
  },
}

</script>
<style scoped>
.error-message {
  color: red;
}

.container {
  transition: all .2s linear;
  display: flex;
  justify-content: center;
  align-items: center;
}

form {
  border: 1px solid #ccc;
  padding: 20px;
  background-color: #f5f4ee;
}

form .row {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}

form .row .col {
  flex: 1 1 250px;
}

form .row .col .title {
  font-size: 20px;
  color: #333;
  padding-bottom: 5px;
  text-transform: uppercase;
}

form .row .col .inputBox {
  margin: 15px 0;
}

form .row .col .inputBox span {
  margin-bottom: 10px;
  display: block;
}

form .row .col .inputBox input {
  border: 1px solid #ccc;
  padding: 10px 15px;
  font-size: 15px;
  text-transform: none;
}

form .row .col .inputBox input:focus {
  border: 1px solid #000;
}

form .row .col .flex {
  display: flex;
  gap: 15px;
}



form .submit-btn {
  width: 100%;
  padding: 12px;
  font-size: 17px;
  background: #243328;
  color: #fff;
  margin-top: 5px;
  cursor: pointer;
}

form .submit-btn:hover {
  background: #ebeadf;
  color: black;
}

.data {
  background-color: #ebeadf;
  width: 60vw;
  padding: 0 5vw;
  height: 83.99vh;
}

.data-card {
  margin: 2em;
  margin-bottom: 0;
  height: 70vh;
  border: 1px solid #ccc;
}

.cart {
  width: 40vw;
  height: 66vh;
  padding: 20px;
  background-color: #243328;
}

.empty-cart {
  font-size: 18px;
  color: #555;
}

.cart-item {
  margin: 10px 0;
  padding: 10px;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 5px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-details {
  flex: 1;
}


.cart-summary {
  margin-top: 20px;
  text-align: right;
}


.card {
  margin-top: 15vh;
  width: 320px;
  height: 190px;
  -webkit-perspective: 600px;
  -moz-perspective: 600px;
  perspective: 600px;
  transition: all 1s;
}

.card__part {
  box-shadow: 1px 1px #aaa3a3;
  top: 0;
  position: absolute;
  z-index: 1000;
  left: 0;
  display: inline-block;
  width: 320px;
  height: 190px;
  background-image: url('../../assets/page-icons/worldwide.png'), linear-gradient(to right bottom, #FFD700, #FFD700, #FFD700, #FFD700, #FFD700);
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
  border-radius: 8px;

  -webkit-transition: all 1s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  -moz-transition: all 1s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  -ms-transition: all 1s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  -o-transition: all 1s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  transition: all 1s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  transform-style: preserve-3d;
  transform-style: preserve-3d;
  backface-visibility: hidden;
  backface-visibility: hidden;
  transition: all 1s;

}

.card__part img {
  width: 50px;
  height: 45px;
}

.card__front {
  padding: 18px;
  transform: rotateY(0);
  transform: rotateY(0);
}

.card__back {
  padding: 18px 0;
  transform: rotateY(-180deg);
  transform: rotateY(-180deg);
}

.card__black-line {
  margin-top: 5px;
  height: 38px;
  background-color: #303030;
}

.card__logo {
  height: 16px;
}

.card__front-logo {
  position: absolute;
  top: 18px;
  right: 18px;
}

.card__square {
  border-radius: 5px;
  height: 30px;
}

.card_numer {
  display: block;
  width: 100%;
  word-spacing: 4px;
  font-size: 20px;
  letter-spacing: 2px;
  color: black;
  text-align: left;
  margin-bottom: 20px;
  margin-top: 20px;
  font-weight: 550;
}

.card__space-75 {
  width: 75%;
  float: left;
}

.card__space-25 {
  width: 25%;
  float: left;
}

.card__label {
  font-size: 10px;
  text-transform: uppercase;
  color: black;
  font-weight: 500;
  letter-spacing: 1px;
}

.card__info {
  margin-bottom: 0;
  margin-top: 5px;
  font-size: 16px;
  line-height: 18px;
  color: black;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.card__back-content {
  padding: 15px 15px 0;
}

.card__secret--last {
  color: #303030;
  text-align: right;
  margin: 0;
  font-size: 14px;
}

.card__secret {
  padding: 5px 12px;
  background-color: #fff;
  position: relative;
}

.card__secret:before {
  content: '';
  position: absolute;
  top: -3px;
  left: -3px;
  height: calc(100% + 6px);
  width: calc(100% - 42px);
  border-radius: 4px;
  background: repeating-linear-gradient(45deg, #ededed, #ededed 5px, #f9f9f9 5px, #f9f9f9 10px);
}

.card__back-logo {
  position: absolute;
  bottom: 15px;
  right: 15px;
}

.card__back-square {
  position: absolute;
  bottom: 15px;
  left: 15px;
}

.card:hover .card__front {
  transform: rotateY(180deg);
  transform: rotateY(180deg);

}

.card:hover .card__back {
  transform: rotateY(0deg);
  transform: rotateY(0deg);
}

.card-back-text-cont {
  margin-top: 7vh;

}

.card-back-text {
  font-size: 10px;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}

.carousel {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.cards {
  flex: 1;
  display: flex;
  justify-content: center;
}

.card__slide-enter-active,
.card__slide-leave-active {
  transition: transform 0.5s;
}

.card__slide-enter,
.card__slide-leave-to {
  transform: translate(100%, 10%);
}

.next-button {
  background-color: transparent;
  border: none;
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 1em;
  margin-top: 20vh;

}

.next-button i {
  font-size: 4em;
  cursor: pointer;
}

.button {
  margin: auto;
  position: relative;
  width: 150px;
  height: 40px;
  cursor: pointer;
  display: flex;
  align-items: center;
  border: 1px solid #34974d;
  background-color: #3aa856;
  transform: translate(1vw, 10vh);
}

.button,
.button__icon,
.button__text {
  transition: all 0.3s;
}

.button .button__text {
  transform: translateX(5px);
  color: #fff;
  font-weight: 600;
}

.button .button__icon {
  position: absolute;
  transform: translateX(109px);
  height: 100%;
  width: 39px;
  background-color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}

.button .svg {
  width: 30px;
  stroke: #2e8644;
}

.button:hover {
  background: #fff;
}

.button:hover .button__text {
  color: transparent;
}

.button:hover .button__icon {
  width: 148px;
  transform: translateX(0);
}

.button:active .button__icon {
  background-color: #fff;
}

.button:active {
  border: 1px solid #fff;
}
</style>