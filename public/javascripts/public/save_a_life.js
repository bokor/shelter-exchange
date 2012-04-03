/*!------------------------------------------------------------------------
 * public/save_a_life.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var SaveALife = {
	initialize: function(latitude, longitude, overlay, marker){
		mapOverlay = overlay;
		logo = marker;
		lat = latitude;
		lng = longitude;
		
		Maps.createMap();
		
		$("#map_auto_scroll").jScroll({top: 50, speed : "slow"});
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			Maps.geocodeAddress();
		});
		
		$("#search_by_city_zipcode").bind("click",function(e, first){
			e.preventDefault();
		});

		SaveALife.searchByCityZipCode();
	},	
	searchByCityZipCode: function() {
		
		// Add Google Map Listener
		idleListener = google.maps.event.addListener(map, 'idle', function(e){
			mapCenter = map.getCenter();
			SaveALife.findAnimalsInBounds();
		});
		
		resizeListener = google.maps.event.addDomListener(window, 'resize', function() {
		  	map.setCenter(mapCenter);
		});
		
		// Set up forms
		SaveALife.bindFilters();
		Maps.breedAutoComplete(function(){SaveALife.findAnimalsInBounds});
		Maps.addressAutoComplete();
  	},
	findAnimalsInBounds: function(){
		var bounds = map.getBounds();
		
		$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
		$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
		
		$.ajax({
			url: "/save_a_life/find_animals_in_bounds",
			type: "get",
			dataType: 'script',
			data: $("#form_filters").serialize(),
			success: function( data ) {
				// Update Google Analytics if production
				if (typeof(_gaq) != "undefined") {  _gaq.push(['_trackPageview', "/save_a_life/search/"+$("#city_zipcode").val()]); } 
			}
		});
	},
	bindFilters: function(){
		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13); 
		});
		
		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			Maps.geocodeAddress();
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
	}
};
