/*!------------------------------------------------------------------------
 * app/communities.js
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

var Communities = {
	initialize: function(latitude, longitude, overlay, marker){
		mapOverlay = overlay;
		logo = marker;
		lat = latitude;
		lng = longitude;
		
		Communities.createMap();
		
		$(".helper_links .toggle_buttons a").bind("click",function(e){
			e.preventDefault();
			$(this).toggleClass("current");
			var div = $(this).attr('href');
			$(div).slideToggle('slow');
		}); 

		$("#search_by_city_zipcode").bind("click",function(e, first){
			e.preventDefault();
			
			$("#map_canvas").stop().animate({marginTop: "0px"},0); // Fixes JScroll issue with hidden elements in the page
			
			$("#results_by_city_zipcode").show();
			$("#results_by_shelter_name").hide();
			$("#form_city_zipcode_search").show();
			$("#form_shelter_name_search").hide();
			//Reset All
			if(!first){ Communities.resetAll(); }

			$(this).parents("ul").find("a").removeClass("current");
			$(this).addClass("current");

			Communities.searchByCityZipCode();
			if($("#city_zipcode").val()){ Communities.geocodeAddress(); }
			
		});

		$("#search_by_shelter_name").bind("click",function(e, first){
			e.preventDefault();
			$("#results_by_city_zipcode").hide();
			$("#results_by_shelter_name").show();
			$("#form_city_zipcode_search").hide();
			$("#form_shelter_name_search").show();
			//Reset All
			if(!first){ Communities.resetAll(); }

			$(this).parents("ul").find("a").removeClass("current");
			$(this).addClass("current");
			Communities.searchByShelterName();
		});
		
		$("#search_by_city_zipcode").trigger("click", true);
	},
	resetAll: function() {
		//Remove Listener
		if(googleListener != null){
			google.maps.event.removeListener(googleListener);
		}

		// Unbind All Form Filters
		$("#form_filters").unbind("keypress");
		$("#form_city_zipcode_search, #form_shelter_name_search").unbind("submit");
		$("#filters_sex, #filters_animal_status, #filters_animal_type").unbind("change");
		$("#filters_euthanasia_only, #filters_special_needs_only").unbind($.browser.msie? "propertychange" : "change");
		
		//Destroy all AutoCompletes
		$("#filters_breed").autocomplete("destroy");
	},	
	createMap: function(){
		// Map setup and config
		myLatLng = new google.maps.LatLng(lat, lng);
		geocoder = new google.maps.Geocoder();
		map      = new google.maps.Map(document.getElementById("map_canvas"), { scrollwheel: false,
	 																		    zoom: defaultZoom,
																				center: myLatLng,
		    																	mapTypeId: google.maps.MapTypeId.ROADMAP});
		
		// kmlLayer = new google.maps.KmlLayer(mapOverlay, { preserveViewport: true });
		kmlLayer = new google.maps.KmlLayer(mapOverlay); // removed zoom in
		kmlLayer.setMap(map);
	},
	searchByCityZipCode: function() {
		
		// Add Google Map Listener
		googleListener = google.maps.event.addListener(map, 'idle', function(e){
			Communities.findAnimalsInBounds();
		});
		
		// Set up forms
		Communities.bindFilters(function(){Communities.findAnimalsInBounds()});
		Communities.breedAutoComplete(function(){Communities.findAnimalsInBounds()});
		Communities.addressAutoComplete();
  	},
	searchByShelterName: function() {
		// Set up and config
	    //myLatLng = new google.maps.LatLng(lat, lng);
	
		if($('#filters_shelter_id').val() != ""){
			Communities.findAnimalsForShelter();
		}
	
		// Set up forms
		Communities.bindFilters(function(){Communities.findAnimalsForShelter()});
		Communities.breedAutoComplete(function(){Communities.findAnimalsForShelter()});
		Communities.shelterNameAutoComplete();
  	},
	findAnimalsInBounds: function(){
		// var zoomLevel = map.getZoom();
		// if (zoomLevel < 10) {
			// $('#all_animals').html( "<p>Please zoom in to search for animals</p>" );
			// $('#urgent_needs_animals').html( "<p>Please zoom in to search for animals</p>" );
		// } else {
			var bounds = map.getBounds();
			$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
			$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
			$.get("/communities/find_animals_in_bounds.js", $("#form_filters").serialize());
		// }
	},
	findAnimalsForShelter: function(){
		$.get("/communities/find_animals_for_shelter.js", $("#form_filters").serialize());
	},
	geocodeAddress: function(){
		geocoder.geocode( { address: $("#city_zipcode").val() + ", USA", region: 'US' }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
				map.fitBounds(results[0].geometry.viewport);
	      	} else {
	        	alert("Your search was unsuccessful.  Please enter a valid City or Zip Code");
	      	}
	    });
	},
	bindFilters: function(findAnimalsFunction){
		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13); 
		});
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			Communities.geocodeAddress();
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
			findAnimalsFunction();
		});
		
		$("#filters_sex, #filters_animal_status").bind("change", function(e){
			e.preventDefault();
			findAnimalsFunction();
		});
		
		$("#filters_euthanasia_only, #filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  	e.preventDefault();
			findAnimalsFunction();
		});
		
	},
	breedAutoComplete: function(findAnimalsFunction){
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
				findAnimalsFunction();
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

/* Scroll map with scrollbar
/*----------------------------------------------------------------------------*/
$(function() {
	$("#map_canvas").jScroll({speed : "slow"});
});