<template>
  <section>
    <b-collapse :open="false" id="collapse-filters">
      <span class="subtitle is-4" slot="trigger" slot-scope="props">
        <b-icon :icon="props.open ? 'caret-down' : 'caret-right'"></b-icon>
        Filters
      </span>
      <div class="field mt-1">
        <b-checkbox
          id='toggle-all-filters'
          @input="toggleAllFilters"
          :value="allFiltersSelected"
          :indeterminate="indeterminateAll"
          >Select all</b-checkbox
        >
      </div>
      <div class="columns">
        <b-collapse
          class="column"
          v-for="(type, index) of filterTypes"
          :key="index"
          :open="initialOpenStatus(index)"
        >
          <span class="subtitle is-5" slot="trigger" slot-scope="props">
            {{ type.name }} <a>{{ props.open ? '-' : '+' }}</a>
          </span>
          <b-checkbox
            :id="`toggle-filters-${type.name}`"
            @input="toggleFilters(type.filters)"
            :value="filterTypeSelectAllValue(type.filters)"
            :indeterminate="indeterminate(type.filters)"
          >
            Select all
          </b-checkbox>
          <ul class="mt-1 test-2">
            <li v-for="filter of type.filters" :key="filter.id">
              <b-checkbox
                :native-value="filter.id"
                :value="currentFilters"
                @input="$emit('change', $event)"
              >
                {{ filter.name }}
                <MappedIconList
                  :iconTypes="[{id: filter.name, name: filter.name}]"
                  v-if="showIconsForFilter(filter.name)"
                  class="is-inline"
                />
              </b-checkbox>
            </li>
          </ul>
        </b-collapse>
      </div>
    </b-collapse>
  </section>
</template>

<script>
import MappedIconList from 'components/MappedIconList'

// TODO: consider extracting a FilterType component.
// see this comment: https://github.com/rubyforgood/mutual-aid/pull/799#pullrequestreview-554188100
export default {
  components: {MappedIconList},
  props: {
    filterTypes: {type: Array, default: () => []},
    currentFilters: {type: Array, default: () => []},
  },
  model: {
    prop: 'currentFilters',
    event: 'change',
  },
  computed: {
    allFiltersSelected: function () {
      return this.allFilters.length === this.currentFilters.length
    },
    indeterminateAll: function () {
      return this.currentFilters.length == 0
        ? false
        : this.currentFilters.length < this.allFilters.length
    },
  },
  methods: {
    initialOpenStatus(index) {
      // return index < 2
      return true
    },
    showIconsForFilter(filterName) {
      return !!this.hasFilterIcons[filterName]
    },
    currentFiltersForFilterType(filterIds) {
      return this.currentFilters.filter((el) => filterIds.includes(el))
    },
    filterTypeSelectAllValue(filters) {
      let filterIds = filters.map((f) => f.id)
      return this.currentFiltersForFilterType(filterIds).length == filterIds.length
    },
    indeterminate(filters) {
      let filterIds = filters.map((f) => f.id)
      return this.currentFiltersForFilterType(filterIds).length == 0
        ? false
        : this.currentFiltersForFilterType(filterIds).length < filterIds.length
    },
    toggleFilters(filters) {
      let filterIds = filters.map((f) => f.id)
      if (this.currentFiltersForFilterType(filterIds).length < filterIds.length) {
        this.$emit('change', [...new Set([...this.currentFilters, ...filterIds])])
      } else {
        this.$emit(
          'change',
          this.currentFilters.filter((el) => !filterIds.includes(el))
        )
      }
    },
    toggleAllFilters() {
      if (this.currentFilters.length < this.allFilters.length) {
        this.$emit('change', this.allFilters)
      } else {
        this.$emit('change', [])
      }
    },
  },
  data() {
    return {
      hasFilterIcons: this.filterTypes
        .map((type) => type.filters)
        .reduce(function (memo, filters) {
          filters.map(function (filter) {
            memo[filter.name] = MappedIconList.iconNameMapping[filter.name]
          })
          return memo
        }, {}),
      allFilters: [].concat(
        ...this.filterTypes.map((fType) => fType.filters.map((filter) => filter.id))
      ),
    }
  },
}
</script>
