/*!------------------------------------------------------------------------
 * app/communities.js
 * ------------------------------------------------------------------------ */
var Communities = {
	initialize: function(latitude, longitude, overlay){
		mapOverlay = overlay;
		lat = latitude;
		lng = longitude;

		Maps.createMap();

		$("#map_canvas").jScroll({speed : "slow"});

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
			if($("#city_zipcode").val() != ""){ Maps.geocodeAddress(); }
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
		if(idleListener != null){ google.maps.event.removeListener(idleListener); }
		if(resizeListener != null){ google.maps.event.removeListener(resizeListener); }

		// Unbind All Form Filters
		$("#form_filters").unbind("keypress");
		$("#form_city_zipcode_search, #form_shelter_name_search").unbind("submit");
		$("#filters_sex, #filters_animal_status, #filters_animal_type").unbind("change");
		$("#filters_euthanasia_only, #filters_special_needs_only").unbind($.browser.msie? "propertychange" : "change");

		//Destroy all AutoCompletes
		$("#filters_breed").autocomplete("destroy");
	},
	searchByCityZipCode: function() {
		// Add Google Map Listener
		idleListener = google.maps.event.addListener(map, 'idle', function(e){
			mapCenter = map.getCenter();
			Communities.findAnimalsInBounds();
		});

		resizeListener = google.maps.event.addDomListener(window, 'resize', function() {
		  map.setCenter(mapCenter);
		});

		// Set up forms
		Communities.bindFilters(function(){Communities.findAnimalsInBounds()});
		Maps.breedAutoComplete(function(){Communities.findAnimalsInBounds()});
		Maps.addressAutoComplete();
  },
	searchByShelterName: function() {
		if($('#filters_shelter_id').val() != ""){
			Communities.findAnimalsForShelter();
		}

		// Set up forms
		Communities.bindFilters(function(){Communities.findAnimalsForShelter()});
		Maps.breedAutoComplete(function(){Communities.findAnimalsForShelter()});
		Maps.shelterNameAutoComplete(function(){Communities.findAnimalsForShelter()});
  },
	findAnimalsInBounds: function(){
		var bounds = map.getBounds();

    $("#filters_map_center").val(mapCenter.toUrlValue());
    $("#filters_distance").val(Maps.viewportDistance());
		$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
		$("#filters_ne").val(bounds.getNorthEast().toUrlValue());

		$.ajax({
			url: "/communities/find_animals_in_bounds.js",
			type: "get",
			dataType: 'script',
			data: $("#form_filters").serialize()
		});

	},
	findAnimalsForShelter: function(){
		$.ajax({
			url: "/communities/find_animals_for_shelter.js",
			type: "get",
			dataType: 'script',
			data: $("#form_filters").serialize()
		});
	},
	bindFilters: function(findAnimalsFunction){
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
	}
};

