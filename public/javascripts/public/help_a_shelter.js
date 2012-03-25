/*!------------------------------------------------------------------------
 * public/help_a_shelter.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var defaultZoom = 11;
var myLatLng = null;
var geocoder = null;
var map = null;
var kmlLayer = null;
var lat = null;
var lng = null;
var mapOverlay = null;
var mapCenter = null;
var logo = null;
var googleListener = null;

var HelpAShelter = {
	initialize: function(latitude, longitude, overlay, marker){
		mapOverlay = overlay;
		logo = marker;
		lat = latitude;
		lng = longitude;
		
		HelpAShelter.createMap();
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			HelpAShelter.geocodeAddress();
		});
		
		$("#search_by_city_zipcode").bind("click",function(e, first){
			e.preventDefault();
		});
		
		HelpAShelter.searchByCityZipCode();

	},	
	filterInitialize: function(){
		HelpAShelter.bindFilters();
		HelpAShelter.breedAutoComplete();
		HelpAShelter.findAnimalsForShelter();
		
	},
	createMap: function(){
		// Map setup and config
		// myLatLng = new google.maps.LatLng(lat, lng);
		// geocoder = new google.maps.Geocoder();
		// map      = new google.maps.Map(document.getElementById("map_canvas"), { scrollwheel: false,
		// 	 																		    zoom: defaultZoom,
		// 																		center: myLatLng,
		//     																	mapTypeId: google.maps.MapTypeId.ROADMAP});
		// To preseve the viewport you have to set the lat and long with the center and default zoom or set the bounds on the map
		// or those fields aren't needed. 
		// kmlLayer = new google.maps.KmlLayer(mapOverlay, { preserveViewport: true });
		
		geocoder = new google.maps.Geocoder();
		map      = new google.maps.Map(document.getElementById("map_canvas"), { scrollwheel: false, mapTypeId: google.maps.MapTypeId.ROADMAP});
		kmlLayer = new google.maps.KmlLayer(mapOverlay); 
		kmlLayer.setMap(map);
	},
	searchByCityZipCode: function() {
		
		// Add Google Map Listener
		googleListener = google.maps.event.addListener(map, 'idle', function(e){
			mapCenter = map.getCenter();
			HelpAShelter.findSheltersInBounds();
		});
		
		google.maps.event.addDomListener(window, 'resize', function() {
		  map.setCenter(mapCenter);
		});
		
		// Set up forms
		HelpAShelter.addressAutoComplete();
  	},
	findSheltersInBounds: function(){
		var bounds = map.getBounds();
		
		$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
		$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
		
		$.ajax({
			url: "/help_a_shelter/find_shelters_in_bounds",
			type: "get",
			dataType: 'script',
			data: $("#form_city_zipcode_search").serialize(),
			success: function( data ) {
				// Update Google Analytics if production
				if (typeof(_gaq) != "undefined") { _gaq.push(['_trackPageview', "/help_a_shelter/search/"+$("#city_zipcode").val()]); }
			}
		});
	},
	findAnimalsForShelter: function(){
		$.ajax({
			url: "/help_a_shelter/find_animals_for_shelter",
			type: "get",
			dataType: 'script',
			data: $("#form_filters").serialize(),
			success: function( data ) {
				// Update Google Analytics if production
				if (typeof(_gaq) != "undefined") { _gaq.push(['_trackPageview', "/help_a_shelter/search/"+$("#filters_shelter_id").val()]); }
			}
		});
	},
	geocodeAddress: function(){
		geocoder.geocode( { address: $("#city_zipcode").val() + ", USA", region: 'US' }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
				map.fitBounds(results[0].geometry.viewport);
				// map.setCenter(results[0].geometry.viewport);
	      	} else {
	        	alert("Your search was unsuccessful.  Please enter a valid City, State or Zip Code");
	      	}
	    });
	},
	bindFilters: function(){
		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13); 
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
			HelpAShelter.findAnimalsForShelter();
		});
		
		$("#filters_sex").bind("change", function(e){
			e.preventDefault();
			HelpAShelter.findAnimalsForShelter();
		});
		
		$("#filters_euthanasia_only, #filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  	e.preventDefault();
			HelpAShelter.findAnimalsForShelter();
		});
		
	},
	breedAutoComplete: function(){
		$("#filters_breed").autocomplete({
			minLength: 0,
			// autoFocus: true,
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
								value: item.name,
								id: item.id
							}  
						}));
					}
				});
			},
			close: function(event, ui) { 
				event.preventDefault();
				HelpAShelter.findAnimalsForShelter();
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
	}
};
