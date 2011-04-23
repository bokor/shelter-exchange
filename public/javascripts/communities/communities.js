var Maps = {
	defaultZoom: 11,
	geocoder: new google.maps.Geocoder(),
	myLatlng: null,
	map: null,
	myOptions: {
		scrollwheel: false,
		zoom: this.defaultZoom,
	    center: this.myLatlng,
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	},
	fileUrl: 'http://www.designwaves.com/shelters.kmz',//?<%=Time.new.to_i%>
	kmlLayer: null,
	initializeMap: function(lat, lng){
		myLatLng = new google.maps.LatLng(lat, lng);
		map = new google.maps.Map(document.getElementById("map_canvas"), this.myOptions);
		kmlLayer = new google.maps.KmlLayer(this.fileUrl, { preserveViewport: true });
		kmlLayer.setMap(map);	
		
		google.maps.event.addListener(map, 'idle', function(e){
			Maps.findAnimalsInBounds();
		});
	},
	geocodeAddress: function(e) {
		geocoder.geocode( { address: $("#address").val() }, function(results, status) {
	     	if (status == google.maps.GeocoderStatus.OK) {
	        	map.setCenter(results[0].geometry.location);
				map.setZoom(this.defaultZoom);
	      	} else {
	        	alert("Geocode was not successful for the following reason: " + status);
	      	}
	    });
  	},
	findAnimalsForShelter: function(map){
	
	},
	findAnimalsInBounds: function(){
		var zoomLevel = map.getZoom();
		if (zoomLevel < 10) {
			$('#all_animals').html( "<p>Please zoom in to search for animals</p>" );
			$('#urgent_needs_animals').html( "<p>Please zoom in to search for animals</p>" );
		} else {
			var bounds = map.getBounds();
			$("#filters_sw").val(bounds.getSouthWest().toUrlValue());
			$("#filters_ne").val(bounds.getNorthEast().toUrlValue());
			$.get("/communities/find_animals_in_bounds.js", $("#form_filters").serialize());
		}
	},
	addMarker: function(myLatlng, map){
		
	}
};





$(function() {
	
	
	
	// Add Listener for City/Zipcode Searching and Map Movement
	
	
	$("#form_address_search").bind("submit", function(e){
		geocodeAddress(e);
		e.preventDefault();
	});
	
	$("#filters_animal_type").bind("change", function(e){
		if($(this).val() == ""){
			$("#breed_field").hide();
		} else {
			$("#breed_field").show();
		}
		$("#filters_breed").val("");
		findAnimalsInBounds();
		e.preventDefault();
	});
	
	$("#filters_sex").bind("change", function(e){
		findAnimalsInBounds();
		e.preventDefault();
	});
	
	$("#filters_animal_status").bind("change", function(e){
		findAnimalsInBounds();
		e.preventDefault();
	});
	
	$("#form_filters").bind("keypress", function(e){
		return !(window.event && window.event.keyCode == 13); 
	});


	// $("#filters_breed").click(function(){
	// 				$("#filters_breed").autocomplete( "search", "" );
	// 			});
	
	$("#filters_breed").autocomplete({
		minLength: 0,
		selectFirst: true,
		html: true,
		delay: 500,
		source: function( request, response ) {
			$.ajax({
				url: "/breeds/auto_complete.json",
				dataType: "json",
				data: {
					q: request.term,
					animal_type_id: $("#filters_animal_type").val()
				},
				success: function( data ) {
					response( $.map( data, function( item ) {
						var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
						var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
						return {
							label: item.name.replace(matcher,'<strong>$1</strong>'),
							value: item.name,
							id: item.id
						}  
					}));
				}
			});
		},
		close: function(event, ui) { 
			findAnimalsInBounds();
			event.preventDefault();
		}			
	});
	
});


