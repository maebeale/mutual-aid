<template>
  <form :action="action" method="post" ref="form">
    <AuthTokenInput />
    <input type="hidden" name="_method" value="delete" />
    <a href="#" :class="classes" v-on:click="submit"><slot /></a>
  </form>
</template>

<script>
import AuthTokenInput from './AuthTokenInput'
export default {
  components: {AuthTokenInput},
  props: {
    action: String,
    classes: {
      default: '',
      type: String,
    },
  },
  methods: {
    submit: function () {
      this.$refs.form.submit()
    },
  },
  computed: {
    authenticityToken() {
      return document.querySelector('meta[name="csrf-token"]').content
    },
  },
}
</script>
