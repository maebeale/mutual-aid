import {createLocalVue, mount, shallowMount} from '@vue/test-utils'
import {configure} from 'vue_config'
import Browse from 'pages/Browse.vue'
import ListBrowser from 'pages/browse/ListBrowser'
import TileBrowser from 'pages/browse/TileBrowser'
import Filters from 'pages/browse/Filters'
import Madlibs from 'pages/browse/Madlibs'

describe('Browse', () => {
  def('wrapper', () => mount(Browse, {
    localVue: configure(createLocalVue())
  }))

  describe('browser view', () => {
    def('showTilesButton', () => $wrapper.find('button#show-tiles'))
    def('showListButton', () => $wrapper.find('button#show-list'))

    it('loads the Filters', function() {
      assert.isTrue($wrapper.contains(Filters))
    })

    describe('starts in Tile view', () => {
      it('renders the TileBrowser', () => {
        assert.isTrue($wrapper.contains(TileBrowser))
        assert.isFalse($wrapper.contains(ListBrowser))
      })

      it('disables the Tile view button', () => {
        assert.equal($showTilesButton.attributes('disabled'), 'disabled')
        assert.notExists($showListButton.attributes('disabled'))
      })
    })

    describe('when switched to the List view', () => {
      beforeEach(async () => {
        $showListButton.trigger('click')
        await $wrapper.vm.$nextTick()
      })

      it('renders the ListBrowser', () => {
        assert.isTrue($wrapper.contains(ListBrowser))
        assert.isFalse($wrapper.contains(TileBrowser))
      })

      it('disables the List view button', () => {
        assert.equal($showListButton.attributes('disabled'), 'disabled')
        assert.notExists($showTilesButton.attributes('disabled'))
      })
    })
  })

  describe("Mablibs filtering", () => {
    def('madlibsTypeDropdown', () => $wrapper.find('select#madlibs-type'))

    describe('when changing the type dropdown', () => {
      beforeEach(async () => {

      })
  
      it("updates the checkboxes when making a dropdown selection", () => {

      })
    })
  })
})
