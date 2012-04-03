/*!------------------------------------------------------------------------
 * shared/formatters.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* URL Formatter :: Prepends http:// to url input fields
/*----------------------------------------------------------------------------*/
$(function(){
	$('.url_formatter').bind('focus', function(e){
	    $(this).val('http://' + $(this).val().replace('http://', ''));
	}).bind('blur', function(e){
		var testStr = $(this).val();
		if (testStr.replace('http://', '') == ''){
			$(this).val("");
		} else {
	    	$(this).val('http://' + $(this).val().replace('http://', ''));
		}
	});
});

$(function(){
	$('.twitter_formatter').bind('focus', function(e){
	    $(this).val('@' + $(this).val().replace('@', ''));
	}).bind('blur', function(e){
		var testStr = $(this).val();
		if (testStr.replace('@', '') == ''){
			$(this).val("");
		} else {
	    	$(this).val('@' + $(this).val().replace('@', ''));
		}
	});
});