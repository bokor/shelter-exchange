/*!------------------------------------------------------------------------
 * admin/users.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Users = {
	liveSearch: function(element){
		// var q = $(element);
		clearTimeout($.data(element, "search_timer"));
		var wait = setTimeout(function() { 
			$.ajax({
				url: "/admin/users/live_search",
				type: "get",
				dataType: 'script',
				data: $("#form_search").serialize()
			});
			clearTimeout($.data(element, "search_timer"));  
		}, 500);
		$.data(element, "search_timer", wait);
	}
};
