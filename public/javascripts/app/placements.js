/* ------------------------------------------------------------------------
 * placements.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Placements = {
	cancelForm: function(id){
		$("#placement_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#placement_"+id).fadeIn(1000);
	}
};






