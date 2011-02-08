var Shelters = {
	loadMap: function(lat, lng){
		var myLatlng = new google.maps.LatLng(lat,lng);
	    var myOptions = {
	      zoom: 13,
	      center: myLatlng,
		  navigationControl: true,
		  mapTypeControl: false,
		  streetViewControl:  false,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    }

	    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

		var infowindow = new google.maps.InfoWindow({
			center: myLatlng,
			position: myLatlng, // Remove this uncomment marker if we want an icon to show up
	        content: $("#map_content").html()
	    });

		var marker = new google.maps.Marker({
			center: myLatlng,
		    position: myLatlng,
		    map: map,
		    icon: '/images/logo_small.png',
			clickable: true
		});

	    // infowindow.open(map, marker);
		google.maps.event.addListener(marker, 'click', function() {
			infowindow.open(map,marker);
		});

		// google.maps.event.trigger(marker,"click"); 

		// Original Code example

		// var infowindow = new google.maps.InfoWindow({
		//     content: contentString
		// });
		// 
		// var marker = new google.maps.Marker({
		//     position: myLatlng,
		//     map: map,
		//     title:"Uluru (Ayers Rock)"
		// });
		// 
		// google.maps.event.addListener(marker, 'click', function() {
		//   infowindow.open(map,marker);
		// });
	}
	
};
