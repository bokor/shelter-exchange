var Accommodations = {
	filterByType: function(element){
		var element = $(element);
		$.get("/accommodations/filter_by_type", element.parents("form:first").serialize());
	},
	filterByCategory: function(element) {
		var element = $(element);
		$.get("/accommodations/filter_by_category", element.parents("form:first").serialize());
  	}
};