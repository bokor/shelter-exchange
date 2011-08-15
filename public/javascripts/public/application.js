/*!------------------------------------------------------------------------
 * public/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
$(function() {

	$(".menu li").bind("click", function(e){
		window.location = $("a", this).attr("href");
	});
	
	$(".flipboxes").bind("click", function(e){

		if($(this).data('flipped')){
			$(this).revertFlip();
			$(this).data("flipped", false);
		} else {
			$(this).flip({
				direction:'rl',
				content:'this is my new content'
			});
			
			$(this).data("flipped", true);
		}
		return false;
	});
	
	

});

