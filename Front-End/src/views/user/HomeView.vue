<template>
  <MainAnnouncement />
  <MainHeader />
  <main>
    <section>
      <HomeBanner />
    </section>

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
    <section class="home__cards">
      <div class="home__cards__text">
        <h1>¡Bienvenidos a Sisviansa!</h1>
        <p>
          Nos enorgullece ofrecer nuestros servicios tanto a usuarios
          individuales como a empresas de todos los tamaños.
        </p>
      </div>
      <article class="home__card">
        <img src="@/assets/imgs/bussiness-banner.png" alt="Imagen ilustrativa para empresas" />
        <div>
          <h2>Empresas</h2>
          <p>
            Lorem, ipsum dolor sit amet consectetur adipisicing elit. Officiis
            asperiores eius dicta nulla laboriosam accusamus doloribus
            repellendus dolorem accusantium cumque ea nihil quam, architecto
            necessitatibus velit praesentium commodi consequuntur numquam?
          </p>
        </div>
      </article>
      <article class="home__card">
        <img src="@/assets/imgs/users-banner.png" alt="Imagen ilustrativa para usuarios" />
        <div>
          <h2>Usuarios</h2>
          <p>
            Lorem ipsum dolor sit amet consectetur adipisicing elit. Sunt,
            laborum? Eaque commodi impedit quam molestiae porro, ipsa et iste
            ullam voluptate consectetur alias enim, magnam, ipsam non. Quaerat,
            nemo corporis?
          </p>
        </div>
      </article>
    </section>
    <section class="home__information">
      <article class="information information__function">
        <h2 class="information__title">¿Cómo funciona nuestro servicio?</h2>
        <div>
          <img src="@/assets/imgs/homepage-function_1.png" alt="Selecciona tu vianda" />
          <img src="@/assets/imgs/homepage-function_2.png" alt="Selecciona tu combo" />
          <img src="@/assets/imgs/homepage-function_3.png" alt="Completa tu pedido" />
        </div>
      </article>
    </section>

    <section class="home__information">
      <article class="information information__what">
        <h2 class="information__title">¿Qué ofrecemos?</h2>
        <div>
          <img src="@/assets/page-icons/gluten.png"
            alt="Imagen ilustrativa mostrando que ofrecemos productos sin gluten" />
          <img src="@/assets/page-icons/vegan.png" alt="Imagen ilustrativa mostrando que ofrecemos productos veganos" />
          <img src="@/assets/icons/isotipo.png" alt="Imagen ilustrativa mostrando que ofrecemos productos veganos" />
          <img src="@/assets/page-icons/vegetarian.png"
            alt="Imagen ilustrativa mostrando que ofrecemos productos vegetarianos" />
          <img src="@/assets/page-icons/personalizable.png"
            alt="Imagen ilustrativa mostrando que ofrecemos menús personalizados" />
        </div>
      </article>
    </section>
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
  background-color: red;
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
  padding-bottom: 5em;
  color: black;
  margin: auto;

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
  padding: 6em;
  background-color: #ebeadf;
  display: flex;
  flex-direction: column;
}

main .home__cards .home__cards__text {
  width: 40vw;
  margin: 1em auto;
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
  width: 90vw;
  margin: auto;
  display: flex;
  flex-direction: row;
}

main .home__cards .home__card div {
  width: 60%;
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
  main .home__information .information__what {
    height: auto;
  }

  main .home__cards .home__cards__text {
    margin-top: 7em;
  }

  main .home__cards .home__card {
    flex-direction: column;
    align-items: flex-start;
  }

  main .home__cards .home__card:nth-child(odd) {
    flex-direction: column;
  }

  main .home__cards .home__card div {
    width: 100%;
    align-items: center;
    padding: 1em;
  }

  main .home__cards .home__card img {
    width: 80%;
    margin-bottom: 1em;
  }
}</style>
