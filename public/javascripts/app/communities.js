/* ------------------------------------------------------------------------
 * app/communities.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var TYPE_SHELTER_NAME = "SHELTER_NAME";
var TYPE_CITY_ZIPCODE = "CITY_ZIPCODE";

var defaultZoom = 11;
var logo;
var myLatLng;
var geocoder;
var kmlLayer;
var map;
var lat;
var lng;
var markersArray = [];

var Communities = {
	
	initializeByCityZipCode: function(lat, lng, s3_url) {
		
		// Map setup and config
		myLatLng = new google.maps.LatLng(lat, lng);
		geocoder = new google.maps.Geocoder();
		map      = new google.maps.Map(document.getElementById("map_canvas"), { scrollwheel: false,
	 																			zoom: defaultZoom,
																				center: myLatLng,
		    																	mapTypeId: google.maps.MapTypeId.ROADMAP});
		
		kmlLayer = new google.maps.KmlLayer(s3_url, { preserveViewport: true });
		kmlLayer.setMap(map);
		
		// Add Google Map Listener
		google.maps.event.addListener(map, 'idle', function(e){
			Communities.findAnimalsInBounds();
		});
		
		// Set up forms
		Communities.bindFilters(TYPE_CITY_ZIPCODE);
		Communities.breedAutoComplete(TYPE_CITY_ZIPCODE);
  	},
	initializeByShelterName: function(lat, lng, marker) {
		logo = marker;
	    myLatLng = new google.maps.LatLng(lat, lng);

		// Set up forms
		Communities.bindFilters(TYPE_SHELTER_NAME);
		Communities.breedAutoComplete(TYPE_SHELTER_NAME);
		Communities.shelterNameAutoComplete();
  	},
	findAnimalsInBounds: function(){
		var zoomLevel = map.getZoom();
		if (zoomLevel < 10) {
			$('#all_animals').html( "<p>Please zoom in to search for animals</p>" );
			$('#urgent_needs_animals').html( "<p>Please zoom in to search for animals</p>" );
		} else {
			var bounds = map.getBounds();
			$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
			$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
			$.get("/communities/find_animals_in_bounds.js", $("#form_filters").serialize());
		}
	},
	findAnimalsForShelter: function(){
		$.get("/communities/find_animals_for_shelter.js", $("#form_filters").serialize());
	},
	geocodeAddress: function(e){
		geocoder.geocode( { address: $("#address").val() }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
	        	map.setCenter(results[0].geometry.location);
				map.setZoom(defaultZoom);
	      	} else {
	        	alert("Geocode was not successful for the following reason: " + status);
	      	}
	    });
	},
	bindFilters: function(type){
		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13); 
		});
		$("#form_address_search").bind("submit", function(e){
			e.preventDefault();
			Communities.geocodeAddress(e);
		});
		
		$("#form_shelter_name_search").bind("submit", function(e){
			e.preventDefault();
		});
		
		$("#filters_animal_type").bind("change", function(e){
			e.preventDefault();
			$("#filters_breed").val("");
			if($(this).val() == ""){
				$("#filters_breed").attr("disabled", true);
				$("#filters_breed").attr("placeholder", "Please select type first");
			} else {
				$("#filters_breed").attr("disabled", false);
				$("#filters_breed").attr("placeholder", "Enter Breed Name");
			}
			if (type == TYPE_SHELTER_NAME){
				Communities.findAnimalsForShelter();
			} else if (type == TYPE_CITY_ZIPCODE){
				Communities.findAnimalsInBounds();
			}
		});
		
		$("#filters_sex, #filters_animal_status, #filters_euthanasia_only").bind("change", function(e){
			e.preventDefault();
			if (type == TYPE_SHELTER_NAME){
				Communities.findAnimalsForShelter();
			} else if (type == TYPE_CITY_ZIPCODE){
				Communities.findAnimalsInBounds();
			}
		});
		
	},
	breedAutoComplete: function(type){
		$("#filters_breed").autocomplete({
			minLength: 0,
			selectFirst: true,
			html: true,
			delay: 500,
			source: function( request, response ) {
				$.ajax({
					url: "/breeds/auto_complete.json",
					dataType: "json",
					data: {
						q: request.term,
						animal_type_id: $("#filters_animal_type").val()
					},
					success: function( data ) {
						response( $.map( data, function( item ) {
							var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
							var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
							return {
								label: item.name.replace(matcher,'<strong>$1</strong>'),
								value: item.name,
								id: item.id
							}  
						}));
					}
				});
			},
			close: function(event, ui) { 
				if (type == TYPE_SHELTER_NAME){
					Communities.findAnimalsForShelter();
				} else if (type == TYPE_CITY_ZIPCODE){
					Communities.findAnimalsInBounds();
				}
				event.preventDefault();
			}			
		});
	},
	shelterNameAutoComplete: function(){
		$("#shelter_name").autocomplete({
			minLength: 3,
			selectFirst: true,
			html: true,
			delay: 500, //maybe 400
			// highlight: true, MAKE EXT LATER
			source: function( request, response ) {
				$.ajax({
					url: "/shelters/auto_complete.json",
					dataType: "json",
					data: {
						q: request.term
					},
					success: function( data ) {
						response( $.map( data, function( item ) {
							var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
							var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
							return {
								lat: item.lat,
								lng: item.lng,
								label: item.name.replace(matcher,'<strong>$1</strong>'),
								value: item.name,
								id: item.id
							}  
						}));
					}
				});
			},
			select: function(event, ui){
				$('#filters_shelter_id').val(ui.item.id);
				Communities.findAnimalsForShelter();
				lat = ui.item.lat;
				lng = ui.item.lng;
			}	
		});
	},
	loadMapForModal: function(){
		Communities.addMap();
		Communities.addMarker();
	},
	addMap: function(){
		map = new google.maps.Map(document.getElementById("map_canvas"), { 	scrollwheel: false,
	    																   	zoom: defaultZoom,
		    															   	center: myLatLng,
																			disableDefaultUI: true,
		    																mapTypeId: google.maps.MapTypeId.ROADMAP });
		map.setCenter(myLatLng);
	},
	addMarker: function(){
		Communities.clearOverlays();
		var marker = new google.maps.Marker({ position: myLatLng,
											  map: map,
											  animation: google.maps.Animation.DROP,
		    								  icon: logo });
		markersArray.push(marker);
	},
	clearOverlays: function(){
	  if (markersArray) {
	    for (i in markersArray) {
	      markersArray[i].setMap(null);
	    }
	  }
	}
};