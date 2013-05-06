/*!------------------------------------------------------------------------
 * shared/fancybox.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* You Tube Link Fancybox and Screenshots
/*----------------------------------------------------------------------------*/
$(function() {

	if(typeof $.fancybox == 'function') {
		$(".screenshot_fancybox").fancybox({
		  titlePosition : 'over',
			transitionIn  : 'none',
			transitionOut : 'none',
			titleFormat   : function(title, currentArray, currentIndex, currentOpts) {
			  return '<span id="fancybox-title-custom">' + title + '</span>';
			}
		});

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
	}
});

