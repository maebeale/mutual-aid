<template>
  <b-navbar fixed-top transparent shadow>
    <template slot="brand">
      <b-navbar-item href="/">
        <img :src="logoUrl" alt="mutual-aid-app logo" height="300px" />
      </b-navbar-item>
    </template>

    <template slot="start">
      <b-navbar-item href="/about">About</b-navbar-item>
      <b-navbar-item href="/community_resources">Community Resources</b-navbar-item>
      <b-navbar-item href="/announcements">Announcements</b-navbar-item>
    </template>

    <template slot="end">
      <b-navbar-item href="/glossary" v-if="visible('Glossary')">Glossary</b-navbar-item>
      <b-navbar-item href="/contributions" v-if="visible('Contributions')"
        >Contributions</b-navbar-item
      >
      <b-navbar-item href="/matches" v-if="visible('Matches')">Matches</b-navbar-item>
      <b-navbar-item tag="div" v-if="visible('Login')">
        <a href="/users/sign_in" class="button is-outlined">Login</a>
      </b-navbar-item>
      <b-navbar-item tag="div" v-if="visible('Sign Up')">
        <a href="/users/sign_up" class="button is-outlined">Sign Up</a>
      </b-navbar-item>
      <b-navbar-item href="/admin" v-if="visible('Admin')">
        Admin
      </b-navbar-item>

      <b-navbar-dropdown label="Account" collapsible right v-if="visible('Logout')">
        <div class="sub-item">
          <a class="navbar-item" href="/users/edit">My profile</a>
        </div>
        <div class="sub-item">
          <FeedbackButton
            classes="navbar-item"
            action="software_feedbacks/new"
            v-if="visible('Feedback')"
            >Feedback</FeedbackButton
          >
        </div>
        <div class="sub-item">
          <DeleteLink classes="navbar-item" action="/users/sign_out">Logout</DeleteLink>
        </div>
      </b-navbar-dropdown>
    </template>
  </b-navbar>
</template>

<script>
import {DeleteLink} from 'components/forms'
import {FeedbackButton} from 'components/forms'
export default {
  props: {
    logoUrl: {type: String},
    visibleButtons: {type: Array, default: []},
  },
  components: {
    DeleteLink,
    FeedbackButton,
  },
  methods: {
    visible(button) {
      return this.visibleButtons.includes(button)
    },
  },
}
</script>
