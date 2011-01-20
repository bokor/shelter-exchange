var Accommodations = {
	liveSearch: function(element,letters_before_search) {
		var element = $(element);
    	// element.down(".close").addClassName("busy");
		if (element.val().length >= letters_before_search) { // Require at least 3 letters before searching
			$.get("/accommodations/live_search", element.parents("form:first").serialize());
		}
  	},
	filterByTypeLocation: function(element) {
		var element = $(element);
		$.get("/accommodations/filter_by_type_location", element.parents("form:first").serialize());
		// $.get("/accommodations/filter_by_type_location", { 
		// 			animal_type_id: $('#animal_animal_type_id').val(), 
		// 			location_id: $('#location_location_id').val() } );
	 }
};