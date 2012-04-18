/*!------------------------------------------------------------------------
 * shared/maps.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var defaultZoom = 11;
var myLatLng = null;
var geocoder = null;
var map = null;
var kmlLayer = null;
var lat = null;
var lng = null;
var mapCenter = null;
var mapOverlay = null;
var logo = null;
var idleListener = null;
var resizeListener = null;

var Maps = {	
	createMap: function(){
		geocoder = new google.maps.Geocoder();
		map      = new google.maps.Map(document.getElementById("map_canvas"), { scrollwheel: false, mapTypeId: google.maps.MapTypeId.ROADMAP});
		kmlLayer = new google.maps.KmlLayer(mapOverlay); 
		kmlLayer.setMap(map);
	},
	geocodeAddress: function(){
		var city_zipcode = $("#city_zipcode").val();
        // var city_zipcode_placeholder = $("#city_zipcode").attr("placeholder");
		if (city_zipcode != ""){ // && city_zipcode != city_zipcode_placeholder) {
			geocoder.geocode( { address: city_zipcode + ", USA", region: 'US' }, function(results, status) {
		     	if (status == google.maps.GeocoderStatus.OK) {
					map.fitBounds(results[0].geometry.viewport);
					// map.setCenter(results[0].geometry.viewport);
		      	} else {
		        	alert("Your search was unsuccessful.  Please enter a valid City, State or Zip Code");
		      	}
		    });
		}
	},
	breedAutoComplete: function(closeFunction){
		$("#filters_breed").autocomplete({
			minLength: 3,
			autoFocus: true,
			delay: 500,
			source: function( request, response ) {
				$.ajax({
					url: "/shared/breeds/auto_complete",
					dataType: "json",
					data: { q: request.term, animal_type_id: $("#filters_animal_type").val() },
					success: function( data ) {
						response( $.map( data, function( item ) {
							return {
								label: item.name, 
								value: item.name
							}  
						}));
					}
				});
			},
			close: function(event, ui) { 
				event.preventDefault();
				closeFunction();
			}			
		});
	},
	addressAutoComplete: function(){
		$("#city_zipcode").autocomplete({
			minLength: 3,
			autoFocus: true,
			delay: 400, 
			source: function(request, response) {
		  	geocoder.geocode( { 'address': request.term + " , USA", 'region': 'us' }, function(results, status) { 
					response( $.map( results, function( item ) {
						var address = item.formatted_address.replace(", USA", "");
						return {
							label: address,
			    		value: address,
 							latitude: item.geometry.location.lat(),
							longitude: item.geometry.location.lng(),
							viewport: item.geometry.viewport
						}  
					}));
		 		})
			},
			//This bit is executed upon selection of an address
			select: function(e, ui) {
				e.preventDefault();
				$(this).val(ui.item.value);
				map.fitBounds(ui.item.viewport);
				lat = ui.item.latitude; 
				lng = ui.item.longitude;
			}	
		});
	},
	shelterNameAutoComplete: function(selectFunction){
		$("#shelter_name").autocomplete({
			minLength: 3,
			autoFocus: true,
			delay: 500, 
			source: function( request, response ) {
				$.ajax({
					url: "/shared/shelters/auto_complete",
					dataType: "json",
					data: {
						q: request.term
					},
					success: function( data ) {
						response( $.map( data, function( item ) {
							return {
								lat: item.lat,
								lng: item.lng,
								label: item.name,
								value: item.name,
								id: item.id
							}  
						}));
					}
				});
			},
			select: function(event, ui){
				$('#filters_shelter_id').val(ui.item.id);
				selectFunction();
				lat = ui.item.lat;
				lng = ui.item.lng;
			}	
		});
	}
};
