var Locations = {
	findByFilter: function(element){
		var element = $(element);
		$.get("/locations/find_by", element.parents("form:first").serialize());
	}
	
};
