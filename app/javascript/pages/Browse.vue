<template>
  <div>
    <div class="intro">
      <h1 class="title">Community Contributions</h1>
      <p class="subtitle is-5">Below are contributions (asks, offers, and community resources) that are available.
        <br>You can filter through them by choosing filter options on the side.
      </p>
    </div>

    <section>
      <section class="mt-3 mb-3">
        <div class="card">
          <div class="card-content">
            <Filters :filterGroupings="filterGroupings" v-model="activeFilters" />
          </div>
        </div>
      </section>
      <section>
        <BrowserSelector :browser="browser" @clicked="browser = $event" />
      </section>
      <component :is="browser" :contributions="activeContributions" class="row" accessToken="pk.eyJ1IjoibXV0dWFsLWFpZC1hcHAiLCJhIjoiY2tmZTBvd3UwMDBhbTJ4cDlic2JmMWZoaiJ9.rWscBjdl1SMT5N0yekIJYg"/>
      <section class="has-text-centered mt-2">
        <h2 class="is-size-4 mb-1">Can't find what you're looking for?</h2>
        <div>
          <a href="/asks/new" class="button is-primary">Submit an Ask</a>
          <a href="/offers/new" class="button is-primary">Submit an Offer</a>
        </div>
      </section>
    </section>
  </div>
</template>

<script>
import BrowserSelector from './browse/BrowserSelector'
import Filters from './browse/Filters'
import ListBrowser from './browse/ListBrowser'
import TileBrowser from './browse/TileBrowser'
import MapBrowser from './browse/MapBrowser'
import ContributionFetcher from './browse/ContributionFetcher'
export default {
  components: {
    BrowserSelector,
    Filters,
    ListBrowser,
    TileBrowser,
    MapBrowser,
  },
  props: {
    contributions: {type: Array},
    filterGroupings: {type: Array, default: ()=>[]},
    initialFilters: {
      type: Array,
      default: function () {
        return [].concat(
          ...this.filterGroupings.map((fGrouping) => fGrouping.filter_options.map((filter_option) => filter_option.id))
        )
      },
    },
    fetcher: {
      type: Object,
      default: () => {
        return new ContributionFetcher('/contributions.json?')
      },
    },
  },
  data() {
    return {
      browser: TileBrowser,
      activeFilters: this.initialFilters,
      activeContributions: this.contributions,
    }
  },
  watch: {
    activeFilters: 'updateContributions',
  },
  methods: {
    updateContributions() {
      if (this.activeFilters == this.initialFilters) {
        return (this.activeContributions = this.contributions)
      }
      this.fetcher.fetch(this.activeFilters, this.activeContributions).then((result) => {
        this.activeContributions = result.data
        if (result.error) this.flashIfError(result.error)
      })
    },
    flashIfError(e) {
      console.log(e)
    },
  },
}
</script>

<style scoped>
  a {
    margin: 0 0.5em;
  }
</style>