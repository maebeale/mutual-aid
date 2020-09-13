<template>
  <div>
    <div class="intro">
      <h1 class="title">Community Contributions</h1>
      <p class="subtitle is-5">Below are contributions (asks, offers, and community resources) that are available.
        <br>You can filter through them by choosing filter options on the side.
      </p>
    </div>

    <madlibs
      :contributions="contributions"
      :filterTypes="filterTypes"
      :initialFilters="initialFilters"
      v-model="activeFilters"
    />

    <section class="section columns">
      <section class="column is-one-quarter">
        <BrowserSelector :browser="browser" @clicked="browser = $event" />

        <Filters :filterTypes="filterTypes" v-model="activeFilters" />
      </section>
      <component :is="browser" :contributions="activeContributions" class="column" />
    </section>
  </div>
</template>

<script>
import BrowserSelector from './browse/BrowserSelector'
import Madlibs from './browse/Madlibs'
import Filters from './browse/Filters'
import ListBrowser from './browse/ListBrowser'
import TileBrowser from './browse/TileBrowser'
import ContributionFetcher from './browse/ContributionFetcher'


export default {
  components: {
    BrowserSelector,
    Filters,
    ListBrowser,
    Madlibs,
    TileBrowser,
  },
  props: {
    contributions: {type: Array},
    filterTypes: {type: Array, default: ()=>[]},
    initialFilters: {
      type: Array,
      default: function () {
        return [].concat(
          ...this.filterTypes.map((fType) => fType.filters.map((filter) => filter.id))
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
    flashIfError(e) {
      console.log(e)
    },
    updateContributions() {
      if (this.activeFilters == this.initialFilters) {
        return (this.activeContributions = this.contributions)
      }
      this.fetcher.fetch(this.activeFilters, this.activeContributions).then((result) => {
        this.activeContributions = result.data
        if (result.error) this.flashIfError(result.error)
      })
    },
  }
}
</script>
