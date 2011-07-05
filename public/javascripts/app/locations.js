/* ------------------------------------------------------------------------
 * app/locations.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Locations = {
	initializeDialog: function(){
		$('.add_location_link a, .close_location_form').bind('click', function(e){
			e.preventDefault();
			$('#create_location').slideToggle(800);
		});
		$('.close_link a').bind('click', function(e){
			e.preventDefault();
			Tipped.hideAll();
		});
	},	
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


