<template>
  <footer class="footer">
    <div class="inner-footer">
      <div class="footer-item">
        <h1 class="footer-title">Sisviansa</h1>
        <p class="footer-description">
          Comprometidos con calidad, nutrición y sabor en cada plato. Ofrecemos opciones sin gluten, veganas y menús
          personalizables para un estilo de vida saludable.
        </p>
      </div>

      <div class="footer-item">
        <h2 class="footer-subtitle">Accesos rápidos</h2>
        <div class="footer-border"></div>
        <ul class="footer-links">
          <li><router-link to="/" class="link">Inicio</router-link></li>
          <li><router-link to="/" class="link">Inicio</router-link></li>
          <li><router-link to="/" class="link">Inicio</router-link></li>
          <li><router-link to="/" class="link">Inicio</router-link></li>
        </ul>
      </div>

      <div class="footer-item">
        <h2 class="footer-subtitle">Contáctanos</h2>
        <div class="footer-border"></div>
        <ul class="footer-contact">
          <li>
            <i class="fa fa-map-marker" aria-hidden="true"></i>Durazno y ejido
          </li>
          <li><i class="fa fa-phone" aria-hidden="true"></i>1234567890</li>
          <li>
            <i class="fa fa-envelope" aria-hidden="true"></i>contacto@sisviansa.com
          </li>
        </ul>
        <div class="footer-social-media">
          <a href="#"><i class="fa fa-facebook" aria-hidden="true"></i></a>
          <a href="#"><i class="fa fa-twitter" aria-hidden="true"></i></a>
          <a href="#"><i class="fa fa-instagram" aria-hidden="true"></i></a>
          <a href="#"><i class="fa-solid fa-envelope"></i></a>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <p class="footer-copyright">
        &copy; Sisviansa 2023. Todos los derechos reservados.
      </p>
    </div>
  </footer>
</template>

<script>
export default {
  name: "MainFooter",
};
</script>
<style lang="css" src="./Footer.css" scoped></style>
