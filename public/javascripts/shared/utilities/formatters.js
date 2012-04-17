/*!------------------------------------------------------------------------
 * shared/formatters.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* URL Formatter :: Prepends http:// to url input fields
/*----------------------------------------------------------------------------*/

$(function(){
	$('.url_formatter').bind('blur', function(e){
	    var urlPattern = /(http|https):\/\//;
		var str = $(this).val();
		if (str.replace(urlPattern, '') == ''){
			$(this).val("");
		} else {
	    	$(this).val('http://' + $(this).val().replace(urlPattern, ''));
		}
	});
});

$(function(){
	$('.twitter_formatter').bind('blur', function(e){
		var str = $(this).val();
		if (str.replace('@', '') == ''){
			$(this).val("");
		} else {
	    	$(this).val('@' + $(this).val().replace('@', ''));
		}
	});
});