<template>
  <a :href="url" :class="classes">
    Feedback
  </a>
</template>

<script>
export default {
  props: {
    classes: {
      default: 'button is-outlined',
      type: String,
    },
  },
  computed: {
    url() {
      const pathname = window.location.pathname
      return `/software_feedbacks/new?page_url=${pathname}`
    },
  },
}
</script>
