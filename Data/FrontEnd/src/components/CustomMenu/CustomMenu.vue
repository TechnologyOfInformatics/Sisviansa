<template>
  <div>
    <MenuCard :custom="custom" :customMenus="customMenus" />
  </div>
</template>

<script>
import MenuCard from "@/components/MenuCard/MenuCard.vue";

export default {
  components: {
    MenuCard,
  },
  data() {
    return {
      custom: false,
      customMenus: [],
    };
  },
  created() {
    this.fetchUserData();
  },
  methods: {
    fetchUserData() {
      const dataToSend = {
        functionName: "options_get_special_menus",
        token: sessionStorage.getItem("miToken"),
      };

      this.$http
        .post("http://localhost/BackEnd/server.php", dataToSend)
        .then((response) => {
          console.log(response.data[0]);
          this.custom = true;
          this.customMenus = response.data[0];
        })
        .catch((error) => {
          console.error(error);
        });
    },
  },
};
</script>
