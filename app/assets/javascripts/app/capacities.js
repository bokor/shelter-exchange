/*!------------------------------------------------------------------------
 * app/capacities.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Capacities = {
	cancelForm: function(id){
		$('#edit_capacity_'+id).slideToggle(800,function() { 
			$(this).remove();
		});
		$('#capacity_'+id).fadeIn(1000);
		
	}
};