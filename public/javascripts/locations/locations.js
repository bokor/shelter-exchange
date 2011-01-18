var Locations = {
	filterByType: function(element){
		var element = $(element);
		$.get("/locations/filter_by_type", element.parents("form:first").serialize());
	},
	filterByCategory: function(element) {
		var element = $(element);
		$.get("/locations/filter_by_category", element.parents("form:first").serialize());
  	}
};