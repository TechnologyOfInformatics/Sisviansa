<template>
    <MainAnnouncement />
    <MainHeader />
    <div class="container">
        <div class="faq" data-aos="fade-up" data-aos-delay="3500" data-aos-duration="1240">
            <div v-for="(question, index) in faqList" :key="index" class="faq-item">
                <div class="question" @click="toggleAccordion(index)">
                    {{ question.title }}
                    <i class="fa-solid fa-arrow-left" :class="{ 'arrow-expanded': question.opened }"></i>
                </div>
                <div class="answer" :class="{ opened: question.opened }">
                    {{ question.answer }}
                </div>
            </div>
        </div>
    </div>
    <ScrollButton />

    <MainFooter />
</template>

  

<script>
import MainAnnouncement from "@/components/Announcement/Announcement.vue";
import MainHeader from "@/components/Header/Header.vue";
import MainFooter from "@/components/Footer/Footer.vue"
import ScrollButton from "@/components/ScrollButton/ScrollButton.vue";


export default {
    components: {
        MainAnnouncement,
        MainHeader,
        MainFooter,
        ScrollButton
    },
    data() {

        return {
            faqList: [
                {
                    title: '¿Cómo puedo restablecer mi contraseña?',
                    answer: 'Haz clic en "¿Olvidaste tu contraseña?" en la página de inicio de sesión y sigue las instrucciones.',
                    opened: false,
                },
                {
                    title: '¿Cuál es el plazo de entrega de los pedidos?',
                    answer: 'Entrega estándar de 3-5 días hábiles, con opciones de envío express disponibles.',
                    opened: false,
                },
                {
                    title: '¿Cómo puedo contactar al soporte técnico?',
                    answer: 'Contacta al equipo de soporte a través del formulario en la página web o enviando un correo a support@sisviansa.com.',
                    opened: false,
                },
                {
                    title: '¿Cuáles son los métodos de pago aceptados?',
                    answer: 'Aceptamos Visa, MasterCard, American Express, PayPal y transferencias bancarias.',
                    opened: false,
                },
                {
                    title: '¿Puedo cancelar mi pedido?',
                    answer: 'Sí, dentro de las primeras 24 horas. Luego, el pedido está en proceso de envío y no se puede cancelar.',
                    opened: false,
                },
                {
                    title: '¿Cómo actualizar mi información personal?',
                    answer: 'Inicia sesión en tu cuenta y ve a "Mi Cuenta" para realizar cambios en tu información.',
                    opened: false,
                },

            ],


        };
    },
    methods: {
        toggleAccordion(index) {
            for (let i = 0; i < this.faqList.length; i++) {
                if (i === index) {
                    this.faqList[i].opened = !this.faqList[i].opened;
                } else {
                    this.faqList[i].opened = false;
                }
            }
        },
    },
};
</script>
  
<style scoped>
.container {
    background-color: #243328;
    width: 100%;
    padding-top: 2em;
    padding-bottom: 2em;

}

.faq {
    margin: 0 auto;
    max-width: 600px;
    padding: 20px;
    background-color: #243328;
    border: 1px solid white;
    border-radius: 5px;
}

.faq-item {
    background-color: #ebeadf;
    margin: 10px auto;
    border: 1px solid #ddd;
    border-radius: 5px;
    overflow: hidden;
    color: black;
}

.question {
    padding: 15px;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: all 0.2s;
}

.question:hover {
    background-color: rgba(98, 143, 110, 0.7);
}

.arrow-expanded {
    transform: rotate(180deg);
}

.answer {
    padding: 15px;
    height: auto;

}

.faq-item .answer {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease-in-out, padding 0.3s ease-in-out;
    padding: 0;
}

.faq-item .answer.opened {
    max-height: 200px;
    padding: 15px;
}

.faq-item .answer:not(.opened) {
    max-height: 0;
    padding: 0;
}
</style>
  