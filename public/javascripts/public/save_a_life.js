/*!------------------------------------------------------------------------
 * public/save_a_life.js
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
var logo = null;
var googleListener = null;

var SaveALife = {
	initialize: function(latitude, longitude, overlay, marker){
		mapOverlay = overlay;
		logo = marker;
		lat = latitude;
		lng = longitude;
		
		SaveALife.createMap();
		
		$("#map_canvas").jScroll({top: 50, speed : "slow"});
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			SaveALife.geocodeAddress();
		});
		
		$("#search_by_city_zipcode").bind("click",function(e, first){
			e.preventDefault();
		});

		SaveALife.searchByCityZipCode();
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
			SaveALife.findAnimalsInBounds();
		});
		
		// Set up forms
		SaveALife.bindFilters();
		SaveALife.breedAutoComplete();
		SaveALife.addressAutoComplete();
  	},
	findAnimalsInBounds: function(){
		var bounds = map.getBounds();
		
		$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
		$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
		$.get("/save_a_life/find_animals_in_bounds.js", $("#form_filters").serialize());
			
		// Update Google Analytics - AJAX Call
		if (typeof(_gaq) != "undefined") {  _gaq.push(['_trackPageview', "/save_a_life/search/"+$("#city_zipcode").val()]); } 
	},
	geocodeAddress: function(){
		geocoder.geocode( { address: $("#city_zipcode").val() + ", USA", region: 'US' }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
				map.fitBounds(results[0].geometry.viewport);
	      	} else {
	        	alert("Your search was unsuccessful.  Please enter a valid City, State or Zip Code");
	      	}
	    });
	},
	bindFilters: function(){
		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13); 
		});
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			SaveALife.geocodeAddress();
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
			SaveALife.findAnimalsInBounds();
		});
		
		$("#filters_sex").bind("change", function(e){
			e.preventDefault();
			SaveALife.findAnimalsInBounds();
		});
		
		$("#filters_euthanasia_only, #filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  	e.preventDefault();
			SaveALife.findAnimalsInBounds();
		});
		
	},
	breedAutoComplete: function(){
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
				event.preventDefault();
				SaveALife.findAnimalsInBounds();
			}			
		});
	},
	addressAutoComplete: function(){
		$("#city_zipcode").autocomplete({
			minLength: 3,
			selectFirst: true,
			html: true,
			delay: 400, 
			source: function(request, response) {
		        geocoder.geocode( { 'address': request.term + " , USA", 'region': 'us' }, function(results, status) { 
				  	response( $.map( results, function( item ) {
						var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
						var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
						var address = item.formatted_address.replace(", USA", "");
						return {
							label: address.replace(matcher,'<strong>$1</strong>'),
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
