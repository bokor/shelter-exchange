/*!------------------------------------------------------------------------
 * admin/shelters.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Shelters = {
	loadMap: function(lat, lng){
		var myLatlng = new google.maps.LatLng(lat,lng);
	    var myOptions = {
	      zoom: 13,
	      center: myLatlng,
		  scrollwheel: false,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    }

	    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

		var marker = new google.maps.Marker({
			center: myLatlng,
		    position: myLatlng,
		    map: map,
		    icon: '/images/logo_small.png',
			clickable: false,
			draggable: false
		});

	},
	liveSearch: function(element){
		var q = $(element);
		clearTimeout($.data(element, "search_timer"));
		var wait = setTimeout(function() { 
			$.get("/admin/shelters/live_search.js", { q: q.val() });
			clearTimeout($.data(element, "search_timer"));  
		}, 500);
		$.data(element, "search_timer", wait);
	}

};
