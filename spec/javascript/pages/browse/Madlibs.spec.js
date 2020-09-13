import {createLocalVue, mount, shallowMount} from '@vue/test-utils'
import {configure} from 'vue_config'
import Madlibs from 'pages/Madlibs.vue'

describe('Madlibs', () => {
  def('wrapper', () => mount(Madlibs, {
    localVue: configure(createLocalVue())
  }))
})
