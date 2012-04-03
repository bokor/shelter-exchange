/*!------------------------------------------------------------------------
 * admin/shelters.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Shelters = {
	initialize: function(lat, lng, s3_url){
		Shelters.loadMap(lat, lng, s3_url);
	},
	loadMap: function(lat, lng, s3_url){
		var myLatLng = new google.maps.LatLng(lat,lng);
	    var myOptions = {
	      zoom: 13,
	      center: myLatLng,
		  scrollwheel: false,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    }

	    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	
		var marker = new google.maps.Marker({
			center: myLatLng,
		    position: myLatLng,
		    map: map,
		    icon: s3_url,
			clickable: false,
			draggable: false
		});

	},
	liveSearch: function(element){
		// var q = $(element);
		clearTimeout($.data(element, "search_timer"));
		var wait = setTimeout(function() { 
			$.ajax({
				url: "/admin/shelters/live_search",
				type: "get",
				dataType: 'script',
				data: $("#form_search").serialize()
			});
			clearTimeout($.data(element, "search_timer"));  
		}, 500);
		$.data(element, "search_timer", wait);
	},	
	cancelForm: function(id){
		$("#edit_shelter_"+id).slideToggle(800,function() { 
			$(this).remove();
		});
		$("#account_"+id).fadeIn(1000);
	}

};
