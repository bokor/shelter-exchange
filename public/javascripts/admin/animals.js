/*!------------------------------------------------------------------------
 * admin/animals.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Animals = {
	liveSearch: function(element){
		clearTimeout($.data(element, "search_timer"));
		var wait = setTimeout(function() {
			$.ajax({
				url: "/admin/animals/live_search",
				type: "get",
				dataType: "script",
				data: $("#form_search").serialize()
			});
			clearTimeout($.data(element, "search_timer"));
		}, 500);
		$.data(element, "search_timer", wait);
	}
};

