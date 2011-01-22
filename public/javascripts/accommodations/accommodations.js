var Accommodations = {
	filterByTypeLocation: function() {
		$.get("/accommodations/filter_by_type_location", { 
			animal_type_id: $('#animal_animal_type_id').val(), 
			location_id: $('#location_location_id').val() 
		});
	}
};