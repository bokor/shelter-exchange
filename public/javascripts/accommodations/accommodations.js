var Accommodations = {
	filterByType: function(element){
		var element = $(element);
		$.get("/accommodations/filter_by_type", element.parents("form:first").serialize());
		$("#location_location_id").val("");
	},
	filterByLocation: function(element) {
		var element = $(element);
		$.get("/accommodations/filter_by_location", element.parents("form:first").serialize());
		$("#animal_animal_type_id").val("");
  	}
};