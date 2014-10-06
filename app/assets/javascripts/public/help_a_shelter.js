/*!------------------------------------------------------------------------
 * public/help_a_shelter.js
 * ------------------------------------------------------------------------ */
var HelpAShelter = {
	initialize: function(latitude, longitude, overlay){
		mapOverlay = overlay;
		lat        = latitude;
		lng        = longitude;

		Maps.createMap();

		$("#form_city_zipcode_search").bind("submit", function(e){
			e.preventDefault();
			Maps.geocodeAddress();
		});

		$("#search_by_city_zipcode").bind("click",function(e, first){
			e.preventDefault();
		});

		HelpAShelter.searchByCityZipCode();
	},
	filterInitialize: function(){
		HelpAShelter.bindFilters();
		Maps.breedAutoComplete(function(){HelpAShelter.findAnimalsForShelter()});
		HelpAShelter.findAnimalsForShelter();

	},
	searchByCityZipCode: function() {

		// Add Google Map Listener
		idleListener = google.maps.event.addListener(map, 'idle', function(e){
			mapCenter = map.getCenter();
			HelpAShelter.findSheltersInBounds();
		});

		resizeListener = google.maps.event.addDomListener(window, 'resize', function() {
		  map.setCenter(mapCenter);
		});

		// Set up forms
		Maps.addressAutoComplete();
  },
	findSheltersInBounds: function(){
		var bounds = map.getBounds();

    $("#filters_map_center").val(mapCenter.toUrlValue());
    $("#filters_distance").val(Maps.viewportDistance());
		$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
		$("#filters_ne").val(bounds.getNorthEast().toUrlValue());

		$.ajax({
			url: "/help_a_shelter/find_shelters_in_bounds.js",
			type: "get",
			dataType: 'script',
			data: $("#form_city_zipcode_search").serialize()
		});
	},
	findAnimalsForShelter: function(){
		$.ajax({
			url: "/help_a_shelter/find_animals_for_shelter",
			type: "get",
			dataType: 'script',
			data: $("#form_filters").serialize()
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

    $('#filters_breed').keyup(function(){
      if(!$.trim(this.value).length){
        HelpAShelter.findAnimalsForShelter();
      }
    });

		$("#filters_sex, #filters_size").bind("change", function(e){
			e.preventDefault();
			HelpAShelter.findAnimalsForShelter();
		});

		$("#filters_euthanasia_only, #filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  	e.preventDefault();
			HelpAShelter.findAnimalsForShelter();
		});
	}
};

