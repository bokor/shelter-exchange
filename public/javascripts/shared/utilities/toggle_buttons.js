/*!------------------------------------------------------------------------
 * shared/toggle_buttons.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */



/* Toggle Helper Links in Help a Shelter and Save a Life.
/*----------------------------------------------------------------------------*/
$(function() {
	$(".helper_links .toggle_buttons a").bind("click",function(e){
		e.preventDefault();
		$(this).toggleClass("current");
		var div = $(this).attr('href');
		$(div).slideToggle('slow');
	});
});










