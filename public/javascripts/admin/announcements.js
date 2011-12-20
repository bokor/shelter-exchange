/*!------------------------------------------------------------------------
 * app/announcements.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Announcements = {
	cancelForm: function(id){
		$("#edit_announcement_"+id).slideToggle(800,function() { 
			$(this).remove();
		});
		$("#announcement_"+id).fadeIn(1000);
	}
};

