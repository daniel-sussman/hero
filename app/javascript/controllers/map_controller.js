import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    homeMarker: String,
    pos: Array  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    if (this.posValue.length > 0) {
      this.map = new mapboxgl.Map({
        container: this.element,
        style: "mapbox://styles/mapbox/streets-v10",
        center: this.posValue,
        zoom: 12
      })
      this.#addHomeMarker();
    } else {
      this.map = new mapboxgl.Map({
        container: this.element,
        style: "mapbox://styles/mapbox/streets-v10",
        center: [-0.128217, 51.508045],
        zoom: 11
      })

    // this.#fitMapToMarkers()
    }
    this.#addMarkersToMap()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_card_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }
  #addHomeMarker() {
    const homeMarker = document.createElement("div")
    homeMarker.innerHTML = this.homeMarkerValue

    new mapboxgl.Marker(homeMarker)
      .setLngLat(this.posValue)
      .addTo(this.map)
  }
  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
