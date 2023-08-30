import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { coords: String }

  connect() {
    this.createMap()
  }

  createMap() {
    const map = new google.maps.Map(this.element, {
      zoom: 10,
      center: { lat: 0, lng: 0 }
    })

    const wellKnownTextLatLngs = this.loadCoordinates()

    this.createPolygon(map, wellKnownTextLatLngs)
  }

  loadCoordinates() {
    const coordinates = this.coordsValue
      .replace('POLYGON((', '')
      .replace('))', '')
      .split(',')

    return coordinates.map((coordinate) => {
      const latLng = coordinate.trim().split(' ')

      return new google.maps.LatLng(
        parseFloat(latLng[1]), parseFloat(latLng[0])
      )
    })
  }

  createPolygon(map, wellKnownTextLatLngs) {
    const polygon = new google.maps.Polygon({
      paths: wellKnownTextLatLngs,
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map
    })

    const bounds = new google.maps.LatLngBounds()

    wellKnownTextLatLngs.forEach((latLng) => {
      bounds.extend(latLng)
    })

    map.fitBounds(bounds)
  }
}
