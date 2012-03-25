/*!------------------------------------------------------------------------
 * app/accommodations.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Accommodations = {
	filterByTypeLocation: function() {
		$.ajax({
			url: "/accommodations/filter_by_type_location",
			type: "get",
			dataType: 'script',
			data: { 
				animal_type_id: $('#animal_animal_type_id').val(), 
				location_id: $('#location_location_id').val() 
			}
		});
	},
	cancelForm: function(id){
		$('#edit_accommodation_'+id).slideToggle(800,function() {
			$(this).remove();
		});
		$('#accommodation_'+id).fadeIn(1000);
		
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