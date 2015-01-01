/*!------------------------------------------------------------------------
 * public/save_a_life.js
 * ------------------------------------------------------------------------ */
var SaveALife = {
	initialize: function(latitude, longitude, overlay){
		mapOverlay = overlay;
		lat        = latitude;
		lng        = longitude;

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

    // Resize Chosen to be fluid
    $('.chosen-container').each(function (index) {
      $(this).css({
        'min-width': '100%',
        'max-width': '100%'
      });
    });
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
		Maps.addressAutoComplete();

    // Bind to chosen change
    $("#filters_breed").chosen().change(function(e, params){
      SaveALife.findAnimalsInBounds();
    });
  },
	findAnimalsInBounds: function(){
		var bounds = map.getBounds();

    $("#filters_map_center").val(mapCenter.toUrlValue());
    $("#filters_distance").val(Maps.viewportDistance());
		$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
		$("#filters_ne").val(bounds.getNorthEast().toUrlValue());

		$.ajax({
			url: "/save_a_life/find_animals_in_bounds.js",
			type: "get",
			dataType: 'script',
			data: $("#form_filters").serialize()
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
      var animalTypeId = $(this).val();
			$("#filters_breed").val("");

			if(animalTypeId == ""){
        $("#filters_breed").empty();
        $("#filters_breed").prepend("<option/>");
        $("#filters_breed").attr('disabled', true);
        $("#filters_breed").attr('data-placeholder', "Please select type first");

        $(".chosen-select").trigger("chosen:updated");
			} else {
        $("#filters_breed").attr('disabled', false);
        $("#filters_breed").attr('data-placeholder', "Type animal breed");
        Breeds.updateChosenByType(animalTypeId, '#filters_breed');

        $(".chosen-select").trigger("chosen:updated");
			}
			SaveALife.findAnimalsInBounds();
			e.preventDefault();
		});

		$("#filters_sex, #filters_size").bind("change", function(e){
			e.preventDefault();
			SaveALife.findAnimalsInBounds();
		});

		$("#filters_euthanasia_only, #filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  e.preventDefault();
			SaveALife.findAnimalsInBounds();
		});
	}
};

