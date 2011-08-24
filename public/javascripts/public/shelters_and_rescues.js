/*!------------------------------------------------------------------------
 * public/shelters_and_rescues.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
/* Fancybox
--------------------------------------------------------------------------- */
$(function() {
	$(".screenshot_fancybox").fancybox({
		titlePosition : 'over',
		transitionIn  : 'none',
		transitionOut : 'none',
		titleFormat   : function(title, currentArray, currentIndex, currentOpts) {
		    return '<span id="fancybox-title-custom">' + title + '</span>';
		}
	});
});