var Locations = {
	filterByType: function(element){
		var element = $(element);
		$.get("/locations/filter_by_type", element.parents("form:first").serialize());
	},
	filterByTag: function(q, element) {
		//remove all current selected
		//$(element).addClass("selected");
		$.get("/locations/filter_by_tag", { q: q });
  	}
};