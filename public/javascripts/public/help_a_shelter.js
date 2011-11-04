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
var logo = null;
var googleListener = null;

var HelpAShelter = {
	initialize: function(latitude, longitude, overlay, marker){
		mapOverlay = overlay;
		logo = marker;
		lat = latitude;
		lng = longitude;
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			HelpAShelter.geocodeAddress();
		});
		
		$("#search_by_city_zipcode").bind("click", function(e){
			e.preventDefault();
		});
		
		HelpAShelter.searchByCityZipCode();

	},	
	searchByCityZipCode: function() {
		// Map setup and config
		myLatLng = new google.maps.LatLng(lat, lng);
		geocoder = new google.maps.Geocoder();
		map      = new google.maps.Map(document.getElementById("map_canvas"), { scrollwheel: false,
	 																		    zoom: defaultZoom,
																				center: myLatLng,
		    																	mapTypeId: google.maps.MapTypeId.ROADMAP});
		
		kmlLayer = new google.maps.KmlLayer(mapOverlay); //, { preserveViewport: true }
		kmlLayer.setMap(map);
		
		// Add Google Map Listener
		googleListener = google.maps.event.addListener(map, 'idle', function(e){
			HelpAShelter.findSheltersInBounds();
		});
		
		// Set up forms
		HelpAShelter.addressAutoComplete();
  	},
	findSheltersInBounds: function(){
		var zoomLevel = map.getZoom();
		// if (zoomLevel < 10) {
			// $('#all_animals').html( "<p>Please zoom in to search for animals</p>" );
			// $('#urgent_needs_animals').html( "<p>Please zoom in to search for animals</p>" );
		// } else {
			var bounds = map.getBounds();
			$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
			$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
			$.get("/help_a_shelter/find_shelters_in_bounds.js", $("#form_city_zipcode_search").serialize());
		// }
	},
	geocodeAddress: function(){
		geocoder.geocode( { address: $("#city_zipcode").val() }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
	        	map.setCenter(results[0].geometry.location);
				map.setZoom(defaultZoom);
	      	} else {
	        	alert("Geocode was not successful for the following reason: " + status);
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
				            longitude: item.geometry.location.lng()
						}  
					}));
		        })
		      },
		      //This bit is executed upon selection of an address
		      select: function(e, ui) {
				e.preventDefault();
			    $(this).val(ui.item.value);
				map.setCenter(new google.maps.LatLng(ui.item.latitude, ui.item.longitude));
				map.setZoom(defaultZoom);
				lat = ui.item.latitude; 
				lng = ui.item.longitude;
		      }	
		});
	}
};

/* Other Initial functionss
/*----------------------------------------------------------------------------*/
$(function() {
	$(".helper_links .toggle_buttons a").bind("click",function(e){
		e.preventDefault();
		$(this).toggleClass("current");
		var div = $(this).attr('href');
		$(div).slideToggle('slow');
	});
	
	$(".shelter").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});
});