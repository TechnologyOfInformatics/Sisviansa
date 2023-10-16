<template>
    <div>
    </div>
  </template>
  
  <script>
  export default {
    created() {
      this.fetchUserData();
    },
    methods: { 
      fetchUserData() {
        const dataToSend = {
          functionName: "options_get_orders",
          token: sessionStorage.getItem('miToken') || 0,
        };
  
        this.$http
          .post("http://localhost/Back-End/server.php", dataToSend)
          .then((response) => {
            console.log(response.data);
          })
          .catch((error) => {
            console.error(error);
          });
      },
    },
  }
  </script>
  