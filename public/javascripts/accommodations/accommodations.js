var Accommodations = {
	filterByTypeLocation: function() {
		$.get("/accommodations/filter_by_type_location.js", { 
			animal_type_id: $('#animal_animal_type_id').val(), 
			location_id: $('#location_location_id').val() 
		});
	}// ,
	// 	liveSearch: function(element){
	// 		var q = $(element);
	// 		if (q.val().length >= 3) {
	// 			clearTimeout($.data(element, "search_timer"));
	// 			var wait = setTimeout(function() { 
	// 				$.get("/accommodations/live_search.js", { q: q.val() });
	// 				clearTimeout($.data(element, "search_timer"));  
	// 			}, 500);
	// 			$.data(element, "search_timer", wait);
	// 		}
	// 	}
};