<template>
  <div class="madlibs">
    <p>
      <span class="madlibs-inline">I am </span>
      <b-select v-model="contributionTypeFilter">
        <option
          v-for="[id, option] in Object.entries(contributionTypes)"
          :value="id"
          :key="id"
        >
          {{ option }}
        </option>
      </b-select>
      <span class="madlibs-inline"> with </span>
      <b-select v-model="contributionCategoryFilter">
        <option
          v-for="[id, category] in Object.entries(contributionCategories)"
          :value="id"
          :key="id"
        >
          {{ category }}
        </option>
      </b-select>
      <span class="madlibs-inline">. I live near </span>
      <b-select v-model="contributionServiceAreaFilter">
        <option
          v-for="[id, serviceArea] in Object.entries(contributionServiceAreas)"
          :value="id"
          :key="id"
        >
          {{ serviceArea }}
        </option>
      </b-select>
      <span class="madlibs-inline">and I need help</span>
      <b-select v-model="contributionTimeFrameFilter">
        <option
          v-for="[id, timeFrame] in Object.entries(contributionTimeFrames)"
          :value="id"
          :key="id"
        >
          {{ timeFrame }}
        </option>
      </b-select>
    </p>
    <p>{{ madlibsFilters.join("&") }}</p>
  </div>
</template>

<script>
const defaultContributionTypes = {
    any: "browsing asks and offers",
    asks: "looking for help",
    offers: "can offer help"
}

export default {
  model: {
    prop: 'activeFilters',
    event: 'change'
  },
  props: {
    activeFilters: {type: Array},
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
  },
  data () {
  	return {
      contributionCategories: {},
      contributionCategoryFilter: 'any',
      contributionServiceAreas: {},
      contributionServiceAreaFilter: 'anywhere',
      contributionTimeFrames: {},
      contributionTimeFrameFilter: 0,
      contributionTypeFilter: 'any',
      contributionTypes: defaultContributionTypes
    }
  },
  computed: {
    madlibsFilters() {
      let filters = []
      return filters.concat(
        this.madlibsTypeFilter,
        this.madlibsCategoryFilter,
        this.madlibsServiceAreaFilter,
        this.madlibsTimeFrameFilter)
    },
    madlibsCategoryFilter() {
      let categoryFilter
      if (this.contributionCategoryFilter == 'any') {
        categoryFilter = this.initialFilters.filter((filter) => {
          return filter.startsWith("Category")
        })
      } else {
        categoryFilter = [`Category[${this.contributionCategoryFilter}]`]
      }
      return categoryFilter
    },
    madlibsServiceAreaFilter() {
      let serviceAreaFilter;
      if (this.contributionServiceAreaFilter == 'anywhere') {
        serviceAreaFilter = this.initialFilters.filter((filter) => {
          return filter.startsWith("ServiceArea")
        })
      } else {
        serviceAreaFilter = [`ServiceArea[${this.contributionServiceAreaFilter}]`]
      }
      return serviceAreaFilter
    },
    madlibsTimeFrameFilter() {
      return [`UrgencyLevel[${this.contributionTimeFrameFilter}]`]
    },
    madlibsTypeFilter() {
      let contributionType;
      if (this.contributionTypeFilter == 'asks') {
        contributionType = ["ContributionType[Ask]"]
      } else if (this.contributionTypeFilter == 'offers') {
        contributionType = ["ContributionType[Offer]"]
      } else {
        contributionType = ["ContributionType[Offer]", "ContributionType[Ask]"]
      }
      return contributionType
    },
  },
  watch: {
    contributionCategoryFilter: 'updateFiltersFromMadlibs',
    contributionServiceAreaFilter: 'updateFiltersFromMadlibs',
    contributionTimeFrameFilter: 'updateFiltersFromMadlibs',
    contributionTypeFilter: 'updateFiltersFromMadlibs'
  },
  mounted: function() {
    this.setMadlibsFilters()
  },
  methods: {
    setMadlibsFilters() {
      let categories = { any: 'any category' }
      let serviceAreas = { anywhere: '(anywhere)' }
      let urgencies = {}
      this.contributions.forEach(contribution => {
        serviceAreas[contribution.service_area.id] = contribution.service_area.name
        urgencies[contribution.urgency.id] = contribution.urgency.name
        if (contribution.urgency.name == 'Anytime') {
          this.contributionTimeFrameFilter = contribution.urgency.id
        }
        contribution.category_tags.forEach(tag => {
          categories[tag.id] = tag.name
        })
      })
      this.contributionCategories = categories
      this.contributionServiceAreas = serviceAreas
      this.contributionTimeFrames = urgencies
    },
    updateFiltersFromMadlibs() {
      this.$emit('change', this.madlibsFilters)
    }
  },
}
</script>

<style scoped>
.madlibs {
  padding-top: 1em;
  font-size: 18pt;
}

.madlibs-inline {
  display: inline-block;
  vertical-align: middle;
}

.control {
  display: inline-block;
  vertical-align: middle;
}
</style>
