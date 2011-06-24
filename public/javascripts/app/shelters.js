/* ------------------------------------------------------------------------
 * app/shelters.js
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
	autoComplete: function(){
		
	}
	
};

$(function(){
	$("#edit_wish_list").bind("click", function(){
		$(this).hide();
	});
});



// var infowindow = new google.maps.InfoWindow({
// 	center: myLatlng,
// 	position: myLatlng, // Remove this uncomment marker if we want an icon to show up
// 	        content: $("#map_content").html()
// 	    });
// infowindow.open(map, marker);
// google.maps.event.addListener(marker, 'click', function() {
// 			infowindow.open(map,marker);
// 		});

