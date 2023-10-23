<template>
  <MainAnnouncement />
  <MainHeader />
  <main>
    <HomeBanner />
    <section class="home__cards">
      <div class="home__cards__text">
        <h1>¡Bienvenidos a Sisviansa!</h1>
        <p>
          Nos enorgullece ofrecer nuestros servicios tanto a usuarios
          individuales como a empresas de todos los tamaños.
        </p>
      </div>
      <article class="home__card">
        <img
          src="@/assets/imgs/bussiness-banner.png"
          alt="Imagen ilustrativa para empresas"
        />
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
        <img
          src="@/assets/imgs/users-banner.png"
          alt="Imagen ilustrativa para usuarios"
        />
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
        <h2 class="information__title">Como funciona nuestro servicio?</h2>
        <div>
          <img
            src="@/assets/imgs/homepage-function_1.png"
            alt="Selecciona tu vianda"
          />
          <img
            src="@/assets/imgs/homepage-function_2.png"
            alt="Selecciona tu combo"
          />
          <img
            src="@/assets/imgs/homepage-function_3.png"
            alt="Completa tu pedido"
          />
        </div>
      </article>
      <article class="information information__what">
        <h2 class="information__title">Que ofrecemos?</h2>
        <div>
          <img
            src="@/assets/page-icons/gluten.png"
            alt="Imagen ilustrativa mostrando que ofrecemos sin gluten"
          />
          <img src="@/assets/page-icons/vegan.png" alt="" />
          <img src="@/assets/page-icons/vegetarian.png" alt="" />
          <img src="@/assets/page-icons/personalizable.png" alt="" />
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

<style scoped>
main {
  width: 95vw;
  margin: 1em auto;
}

main .home__information .information {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

main .home__information .information__title {
  margin: 25px;
  padding: 0 2em;
  text-decoration: underline;
  font-family: "Helvetica Neue", Arial, sans-serif;
  font-size: 36px;
  text-align: center;
  color: black;
  padding: 10px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
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
}

main .home__information .information__what div img {
  width: 200px;
  margin: 1em 0;
}

main .home__cards {
  max-width: 80%;
  margin: auto;
  margin-bottom: 1em;
  margin-top: 2em;
  display: flex;
  flex-direction: column;
}

main .home__cards .home__cards__text {
  width: 40vw;
  margin: 1em auto;
}

main .home__cards .home__cards__text h1 {
  font-size: 1.5em;
  text-align: center;
}

main .home__cards .home__cards__text p {
  text-align: center;
  font-size: 0.9em;
}

main .home__cards .home__card {
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
}
</style>
