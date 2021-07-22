<template>
  <section class="MapBrowser">
    <!-- FIXME Pull access-token via environment variable -->
    <mapbox
      :access-token= this.accessToken
      :map-options="{
        style: 'mapbox://styles/mapbox/streets-v11',
        center: [-96, 37.8],
        zoom: 4,
      }"
      :geolocate-control="{
        show: true,
        position: 'top-left',
      }"
      @map-load="loaded"
      @map-zoomend="zoomend"
      @map-click:points="clicked"
      @geolocate-error="geolocateError"
      @geolocate-geolocate="geolocate"
      @map-init="initialized"
      v-if="contributions.length > 0"
    />

     <div v-if="contributions.length === 0">
      <p style="text-align: center;">No match found.</p>
    </div>
  </section>
</template>

<script>
  import Mapbox from 'mapbox-gl-vue'
  const mbxClient = require('@mapbox/mapbox-sdk');
  const geoCoding = require('@mapbox/mapbox-sdk/services/geocoding');
  //  FIXME Attempt to pass accessToken in script tag as seen in line 6
  const baseClient = mbxClient({ accessToken: "pk.eyJ1IjoibXV0dWFsLWFpZC1hcHAiLCJhIjoiY2tmZTBvd3UwMDBhbTJ4cDlic2JmMWZoaiJ9.rWscBjdl1SMT5N0yekIJYg"});
  const geoCodingService = geoCoding(baseClient)

  export default {
    props: {
      accessToken: String,
      contributions: {type: Array, default: () => []},
      filters: Object,
    },
    components: { Mapbox },
    methods: {
      zoomend(map, e) {
        console.log('Map zoomed')
      },
      clicked(map, e) {
        const title = e.features[0].properties.title
        console.log(title)
      },
      geolocateError(control, positionError) {
        console.log(positionError)
      },
      geolocate(control, position) {
        console.log(
          `User position: ${position.coords.latitude}, ${position.coords.longitude}`
        )
      },
      geocode(contributions) {
        let geojson = {
          type: 'FeatureCollection',
          features: [],
        }
        return new Promise((resolve) => {
          let forwarded = 0
          if (contributions.length == 0) resolve(geojson)
          contributions.forEach((contribution) => {
            geoCodingService
              .forwardGeocode({
                query: `${
                  contribution.location && contribution.location.street_address
                    ? contribution.location.street_address
                    : ''
                } ${contribution.service_area.location.city} ${
                  contribution.service_area.location.state
                } ${contribution.service_area.location.zip_code}`,
                limit: 1,
              })
              .send()
              .then((response) => {
                ++forwarded
                const match = response.body
                geojson.features = [
                  ...geojson.features,
                  {
                    type: 'Feature',
                    properties: {
                      title: contribution.name,
                      description: contribution.description ? contribution.description : '',
                      categoryTag: contribution.category_tags[0].name,
                      urgency: contribution.urgency ? contribution.urgency : '',
                      icon: 'harbor',
                      iconSize: [50, 50],
                      contributionType: contribution.contribution_type,
                    },
                    geometry: {
                      type: 'Point',
                      coordinates: match.features[0].center,
                    },
                  },
                ]
              })
              .then(() => {
                if (forwarded === contributions.length) resolve(geojson)
              })
              .catch((e) => console.log(e))
          })
        })
      },
      add_markers: function (geojson, map) {
        if (map.getLayer('points')) {
          map.removeLayer('points')
        }
        if (map.getSource('points')) {
          map.removeSource('points')
        }
        map.addLayer({
          id: 'points',
          type: 'symbol',
          source: {
            type: 'geojson',
            data: geojson,
          },
          layout: {
            'text-font': ['Open Sans Semibold', 'Arial Unicode MS Bold'],
            'text-offset': [0, 0.6],
            'text-anchor': 'top',
          },
        })
        var bounds = new mapboxgl.LngLatBounds()
        geojson.features.forEach((marker) => {
          var el = document.createElement('div')
          el.className = 'marker ' + marker.properties.contributionType.toLowerCase() + '-marker'
          el.style.width = marker.properties.iconSize[0] + 'px'
          el.style.height = marker.properties.iconSize[1] + 'px'
          const newMarker = new mapboxgl.Marker(el)
            .setLngLat(marker.geometry.coordinates)
            .setPopup(
              new mapboxgl.Popup({offset: 35}).setHTML(
                '<h3>' +
                  marker.properties.title +
                  '</h3><p>' +
                  marker.properties.categoryTag +
                  '</p><p>' +
                  marker.properties.description +
                  '</p>'
              )
            )
          newMarker.addTo(map)
          bounds.extend(marker.geometry.coordinates)
        })
        map.fitBounds(bounds, {padding: 50})
      },
      loaded: function () {
        this.geocode(this.contributions).then((geojson) => this.add_markers(geojson, this.map))
      },
      initialized: function (map) {
        this.map = map
      },
    },
    data() {
      return {
        map: null,
      }
    },
    watch: {
      contributions: function (new_val, old_val) {
        if (new_val.length > 0 && !(JSON.stringify(new_val) === JSON.stringify(old_val))) {
          this.geocode(new_val).then((geojson) => this.add_markers(geojson, this.map))
        }
      },
    },
}
</script>
