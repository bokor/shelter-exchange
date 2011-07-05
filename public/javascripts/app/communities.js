/* ------------------------------------------------------------------------
 * app/communities.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Communities = {
	geocoder: null,
	map: null,
	
	initialize: function(lat, lng, s3_url) {
		
		// Map setup and config
		var myLatLng = new google.maps.LatLng(lat, lng);
		var myOptions = {
			scrollwheel: false,
	 		zoom: 11,
			center: myLatLng,
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		geocoder = new google.maps.Geocoder();
		map      = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
		
		var kmlLayer = new google.maps.KmlLayer(s3_url, { preserveViewport: true });
		kmlLayer.setMap(map);
		
		// Add Google Map Listener
		google.maps.event.addListener(map, 'idle', function(e){
			Communities.findAnimalsInBounds();
		});
		
		// Set up forms
		Communities.bindFilters();
		Communities.breedAutoComplete();
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
	bindFilters: function(){
		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13); 
		});
		$("#form_address_search").bind("submit", function(e){
			e.preventDefault();
			Communities.geocodeAddress(e);
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
			Communities.findAnimalsInBounds();
		});
		
		$("#filters_sex, #filters_animal_status, #filters_euthanasia_only").bind("change", function(e){
			e.preventDefault();
			Communities.findAnimalsInBounds();
		});
		
	},
	breedAutoComplete: function(){
		
		// $("#filters_breed").click(function(){
		// 				$("#filters_breed").autocomplete( "search", "" );
		// 			});
		
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
				Communities.findAnimalsInBounds();
				event.preventDefault();
			}			
		});
	}
};