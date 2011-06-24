/* ------------------------------------------------------------------------
 * app/locations.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Locations = {
	findAllLocations: function() {
		$.get("/locations/find_all.js");
  	},
	cancelForm: function(id){
		$('#edit_location_'+id).slideToggle(800,function() {
			$(this).remove();
		});
		$('#location_'+id).fadeIn(1000);
	}
};


