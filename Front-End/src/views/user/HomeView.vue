<template>
  <MainAnnouncement />
  <MainHeader />
  <main>
    <section>
      <HomeBanner />
    </section>
    <div data-aos="fade-up" data-aos-delay="3500">
      <section class="home__beginning">
        <div class="home__beginning_title">
          <h1>Nuestros principios</h1>
        </div>
        <div class="home__beginning_boxes">
          <article>
            <h2>Nuestra Visión</h2>
            <p>Ser líderes en viandas saludables, inspirando un estilo de vida más saludable.</p>
          </article>
          <article>
            <h2>Nuestros Valores</h2>
            <ul>
              <li>Salud y Nutrición.</li>
              <li>Calidad.</li>
              <li>Creatividad y Variedad.</li>
              <li>Excelencia en el Servicio al Cliente.</li>
              <li>Ética Empresarial.</li>
            </ul>
          </article>
          <article>
            <h2>Nuestra Misión</h2>
            <p>Ofrecer comidas saludables y deliciosas que promuevan el bienestar.</p>
          </article>
        </div>
      </section>
    </div>
    <div data-aos="fade-up">

      <section class="home__cards">
        <div data-aos="zoom-in-up">

          <div class="home__cards__text">
            <h1>¡Bienvenidos a Sisviansa!</h1>
            <p>
              Nos enorgullece ofrecer nuestros servicios tanto a usuarios
              individuales como a empresas de todos los tamaños.
            </p>
          </div>
        </div>
        <article class="home__card">
          <img src="@/assets/imgs/bussiness-banner.png" alt="Imagen ilustrativa para empresas" />
          <div>
            <h2>Empresas</h2>
            <p>
              Ofrecemos opciones de comida saludable de alta calidad para empresas de todos los
              tamaños. Nuestros menús personalizables satisfacen las necesidades de tu equipo y promueven un estilo de
              vida
              más saludable.
            </p>
          </div>
        </article>
        <div data-aos="flip-right" data-aos-easing="linear" data-aos-duration="440">
          <article class="home__card">
            <img src="@/assets/imgs/users-banner.png" alt="Imagen ilustrativa para usuarios" />
            <div>
              <h2>Usuarios</h2>
              <p>
                Disfruta de opciones deliciosas y saludables, como productos sin gluten, veganos y
                más. Únete a nuestro viaje hacia un estilo de vida más saludable.
              </p>
            </div>
          </article>
        </div>

      </section>
    </div>
    <section class="home__company-info">
      <article>
        <h2>Conoce la mejor empresa de viandas saludables</h2>
        <div>
          <img src="@/assets/icons/isotipo.png">
        </div>
        <p>Sisviansa</p>
      </article>
    </section>

    <section class="home__information">
      <article class="information information__function">
        <h2 class="information__title">¿Cómo funciona nuestro servicio?</h2>
        <div data-aos="fade-zoom-in" data-aos-delay="300" data-aos-offset="0" data-aos-easing="linear"
          data-aos-duration="1500">

          <div>
            <img src="@/assets/imgs/homepage-function_1.png" alt="Selecciona tu vianda" />

            <img src="@/assets/imgs/homepage-function_2.png" alt="Selecciona tu combo" />
            <img src="@/assets/imgs/homepage-function_3.png" alt="Completa tu pedido" />
          </div>
        </div>
      </article>
    </section>
    <div data-aos="zoom-in-left">

      <section class="home__information">
        <article class="information information__what">
          <h2 class="information__title">¿Qué ofrecemos?</h2>
          <div data-aos="zoom-in" data-aos-easing="linear" data-aos-duration="600">
            <div>
              <img src="@/assets/page-icons/gluten.png"
                alt="Imagen ilustrativa mostrando que ofrecemos productos sin gluten" />
              <img src="@/assets/page-icons/vegan.png"
                alt="Imagen ilustrativa mostrando que ofrecemos productos veganos" />

              <img src="@/assets/icons/isotipo.png" alt="Imagen ilustrativa mostrando que ofrecemos productos veganos" />
              <img src="@/assets/page-icons/vegetarian.png"
                alt="Imagen ilustrativa mostrando que ofrecemos productos vegetarianos" />
              <img src="@/assets/page-icons/personalizable.png"
                alt="Imagen ilustrativa mostrando que ofrecemos menús personalizados" />
            </div>
          </div>
        </article>
      </section>
    </div>
  </main>
  <MainFooter />
  <ScrollButton />
</template>

<script>
import MainAnnouncement from "@/components/Announcement/Announcement.vue";
import MainHeader from "@/components/Header/Header.vue";
import MainFooter from "@/components/Footer/Footer.vue";
import HomeBanner from "@/components/Carrousel/Carrousel.vue";
import ScrollButton from "@/components/ScrollButton/ScrollButton.vue";

export default {
  name: "HomeView",
  components: {
    MainAnnouncement,
    MainHeader,
    MainFooter,
    HomeBanner,
    ScrollButton,
  },

};
</script>

<style lang="css" scoped>
main {
  background-color: #243328;

}


main .home__information .information__function {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #eceff3;
  height: 85vh;
  padding-bottom: 5em;
  margin: auto;
}

main .home__information .information__what {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-color: #ebeadf;
  height: 85vh;
  padding-bottom: 1em;
  color: black;
  margin: auto;

}

main .home__company-info {
  background-color: #243328;
  padding: 5em 0;
  text-align: center;
}

main .home__company-info h2 {
  font-size: 1.8em;
  color: #ffffff;
  margin-bottom: 1em;
}

main .home__company-info div {
  width: 20vw;
  height: 20vw;
  border-radius: 50%;
  background-color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2em;
  margin: 0 auto;
  margin-bottom: 1em;
}


main .home__company-info p {
  color: #ffffff;
  font-size: 1em;
  margin-top: 1em;
}


main .home__information .information__title {
  padding: 3em 0 2em;
  font-size: 1.8em;
  text-align: center;
}

main .home__information .information div {
  width: 100%;
  margin: auto;
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
  align-items: center;
  flex-wrap: wrap;
}

main .home__information .information__function div img {
  width: 300px;
  margin: 1em 0;
  border-radius: 5px;
  box-shadow: 0 0 15px rgba(135, 175, 65, 1);
  transition: all 3s;
  cursor: pointer;

}

main .home__information .information__function div img:hover {
  transform: scale(1.05);
}

main .home__information .information__what div img {
  width: 200px;
  margin: 1em 0;
}

main .home__beginning {
  height: 85vh;
  margin: auto;
  background-color: white;
}

main .home__beginning .home__beginning_title {
  padding: 3em 0 2em;
  font-size: 1.3em;
  text-align: center;
}

main .home__beginning .home__beginning_boxes {
  display: flex;
  flex-direction: row;
  align-items: center;
  text-align: center;
  justify-content: center;
  padding-bottom: 1em;
}

main .home__beginning .home__beginning_boxes article {
  margin-left: 10px;
  width: 25vw;
  height: 20vw;
  background-color: #ebeadf;
}

main .home__beginning .home__beginning_boxes article h2 {
  font-size: 1.2em;
  padding: 3em 0 1em;
}

main .home__beginning .home__beginning_boxes article p,
main .home__beginning .home__beginning_boxes article li {
  font-family: 'Inter', sans-serif;
  font-size: 1.1em;
  padding: 0 3em;
  list-style: none;

}

main .home__cards {
  padding: 2em;
  background-color: #ebeadf;
  display: flex;
  flex-direction: column;
}

main .home__cards .home__cards__text {
  width: 40vw;
  margin: 1em auto 4em;
}

main .home__cards .home__cards__text h1 {
  font-size: 1.6em;
  text-align: center;
}

main .home__cards .home__cards__text p {
  text-align: center;
  font-size: 1.3em;
}

main .home__cards .home__card {
  width: 95vw;
  margin: auto;
  display: flex;
  flex-direction: row;
  padding-top: 2em;
  padding-bottom: 2em;
}

.home__cards .home__card:nth-child(2) {

  background-color: white;
  border-radius: 15px;
}



main .home__cards .home__card div {
  width: 50%;
  margin: auto;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

main .home__cards .home__card:nth-child(odd) {
  flex-direction: row-reverse;
}

main .home__cards .home__card div p {
  margin: 1em 0;
  font-size: 1.1em;
}

main .home__cards .home__card div h2 {
  font-size: 1.2em;
}

main .home__cards .home__card img {
  width: 40%;
  margin: 1em 2em;
}


@media (max-width: 768px) {


  main .home__information .information__function,
  main .home__information .information__what,
  main .home__beginning {
    height: auto;
  }

  main .home__cards {
    padding: 0;
  }

  main .home__cards .home__cards__text {
    margin-top: 7em;
    width: 80vw;
  }

  main .home__cards .home__card {
    flex-direction: column;
    align-items: flex-start;
  }

  main .home__cards .home__card:nth-child(odd) {
    flex-direction: column;
  }

  main .home__cards .home__card div {
    width: 90%;
    align-items: center;
    padding: 1em;
  }

  main .home__cards .home__card img {
    width: 80%;
    margin-bottom: 1em;
  }

  main .home__beginning .home__beginning_boxes {
    flex-direction: column;
  }

  main .home__beginning .home__beginning_boxes article {
    margin-top: 10px;
    width: 70vw;
    height: 80vw;
    background-color: #ebeadf;
  }

  main .home__company-info div img {
    width: 20em;
  }

  main .home__company-info div {
    width: 49vw;
    height: 22.5vh;
  }
}
</style>
