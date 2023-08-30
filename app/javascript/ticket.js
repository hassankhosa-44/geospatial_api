window.initializeMap = function () {
  if(!document.getElementById('map-canvas')) return;

  var map = new google.maps.Map(document.getElementById('map-canvas'), {
    zoom: 10,
    center: { lat: 0, lng: 0 }
  });
  const ticket_data = document.getElementById('map-canvas').getAttribute('data-polygon')

  var wellKnownText = ticket_data;
  var coordinates = wellKnownText
    .replace('POLYGON((', '')
    .replace('))', '')
    .split(',');

  var wellKnownTextLatLngs = coordinates.map(function(coordinate) {
    var latLng = coordinate.trim().split(' ');
    return new google.maps.LatLng(parseFloat(latLng[1]), parseFloat(latLng[0]));
  });

  var polygon = new google.maps.Polygon({
    paths: wellKnownTextLatLngs,
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: '#FF0000',
    fillOpacity: 0.35,
    map: map
  });

  var bounds = new google.maps.LatLngBounds();
  wellKnownTextLatLngs.forEach(function(latLng) {
    bounds.extend(latLng);
  });
  map.fitBounds(bounds);
}

window.initializeMap();
