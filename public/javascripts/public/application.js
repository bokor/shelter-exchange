/*!------------------------------------------------------------------------
 * public/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
$(function() {

	$(".menu li").bind("click", function(e){
		window.location = $("a", this).attr("href");
	});

});