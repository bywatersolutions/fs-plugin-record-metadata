<template>
  <div v-if="token" ref="notice" class="dialog message alert alert-info">
    <slot />
  </div>
</template>

<script>
export default {
  name: "SaveNotice",
  props: {
    token: { type: [Number, String, Object], default: null },
  },
  watch: {
    token(val) {
      if (!val) return;
      this.$nextTick(() => {
        if (this.$refs.notice) {
          this.$refs.notice.scrollIntoView({ behavior: "smooth", block: "nearest" });
        }
      });
    },
  },
};
</script>
