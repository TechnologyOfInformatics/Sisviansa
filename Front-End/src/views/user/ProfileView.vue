<template>
    <MainHeader />
    <div>a</div>
  </template>
  
  <script>
  import MainHeader from "@/components/Header/Header.vue";
  
  export default {
    components: {
      MainHeader,
    },
    data() {
      return {
        login: true,
      };
    },
    methods: {
      validateUserData() {
        const token = sessionStorage.getItem('miToken') || '12345678';
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
              if (response.data[0] !== true) {
                this.$router.push('/login');
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
  };
  </script>

  
  