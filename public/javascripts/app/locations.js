/*!------------------------------------------------------------------------
 * app/locations.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Locations = {
	initializeDialog: function(){
		$('.add_location_link a, .close_location_form').bind('click', function(e){
			e.preventDefault();
			$('#create_location').slideToggle(800);
		});
		//$('.close_link a').bind('click', function(e){
		//	e.preventDefault();
		//	$('.qtip.ui-tooltip').qtip('hide');
		//});
	},	
	findAllLocations: function() {
		$.ajax({
			url: "/locations/find_all",
			type: "get",
			dataType: 'script'
		});
  	},
	cancelForm: function(id){
		$('#edit_location_'+id).slideToggle(800,function() {
			$(this).remove();
		});
		$('#location_'+id).fadeIn(1000);
	}
};


