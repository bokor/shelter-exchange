/*!------------------------------------------------------------------------
 * shared/video.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* You Tube Link Fancybox
/*----------------------------------------------------------------------------*/
$(function() {

	$(".video_player").fancybox({
		transitionIn : 'fade',
		transitionOut : 'fade',
		titlePosition : 'inside',
		autoScale : true,
		autoDimensions : true,
		centerOnScroll : true,
		type : 'swf'
	});

	$(".popup_fancybox").fancybox({
		width : 980,
		height: 550,
		transitionIn : 'elastic',
		transitionOut : 'elastic',
		type : 'iframe'
	});

});