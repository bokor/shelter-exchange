var Maps = {
	geocodeAddress: function(e, geocoder, map) {
		geocoder.geocode( { address: $("#address").val() }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
	        	map.setCenter(results[0].geometry.location);
	      	} else {
	        	alert("Geocode was not successful for the following reason: " + status);
	      	}
	    });
  	},
	addListeners: function(map) {
		google.maps.event.addListener(map, 'idle', function(){
			Maps.findAnimalsInBounds(map);
		});
	},
	removeListeners: function(map){
		google.maps.event.clearListeners(map, 'idle');
	},
	findAnimalsForShelter: function(map){
		var zoomLevel = map.getZoom();
		if (zoomLevel < 10) {
			$('#all_animals').html( "<h2>Please zoom in to search for animals</h2>" );
			$('#urgent_needs_animals').html( "<h2>Please zoom in to search for animals</h2>" );
		} else {
			var shelterName = $('#shelter_name').val();
			$.get("/maps/find_animals_for_shelter.js", { shelter_name: shelterName });
		}
	},
	findAnimalsInBounds: function(map){
		var zoomLevel = map.getZoom();
		if (zoomLevel < 10) {
			$('#all_animals').html( "<h2>Please zoom in to search for animals</h2>" );
			$('#urgent_needs_animals').html( "<h2>Please zoom in to search for animals</h2>" );
		} else {
			var bounds = map.getBounds();
			var sw = bounds.getSouthWest().toUrlValue();
			var ne = bounds.getNorthEast().toUrlValue();
			$.get("/maps/find_animals_in_bounds.js", { sw: sw, ne: ne });
		}
	},
	addMarker: function(myLatlng, map){
		var marker = new google.maps.Marker({
			center: myLatlng,
		    position: myLatlng,
		    map: map,
		    icon: '/images/logo_small.png',
			clickable: true
		});
	}
};


// var infowindow = new google.maps.InfoWindow({
// 	center: myLatlng,
// 	position: myLatlng, // Remove this uncomment marker if we want an icon to show up
//     content: $("#map_content").html()
// });
// 
// var marker = new google.maps.Marker({
// 	center: myLatlng,
//     position: myLatlng,
//     map: map,
//     icon: '/images/logo_small.png',
// 	clickable: true
// });

// infowindow.open(map, marker);
// google.maps.event.addListener(marker, 'click', function() {
// 	infowindow.open(map,marker);
// });
