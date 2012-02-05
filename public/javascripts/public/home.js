/*!------------------------------------------------------------------------
 * public/home.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
/* Home Page Slider
--------------------------------------------------------------------------- */
$(function() {
    $('#slider').nivoSlider({
		effect:'fade', // Specify sets like: 'fold,fade,sliceDown'
	    animSpeed:800, // Slide transition speed
        pauseTime:8000 // How long each slide will show
	});
});

/* Newsletter Form
--------------------------------------------------------------------------- */
$(function() {
	$('#newsletter_form input[type=text]').bind('focus', function(e){
		$(this).val('');
		$(this).removeClass("error");
	}).bind('blur', function(e){
		var blurStr = $(this).val();
		if (blurStr == ''){
			$(this).val("Enter email address");
		} 
	});
	
	$("#newsletter_form").submit(function(e){  
		e.preventDefault();

		var email = $(this).find("input[type=text]").val();
		var valid = validateEmail(email);
		if (valid){
			$.post("https://shelterexchange.wufoo.com/forms/x7x1x7/#public", $(this).serialize());  
			$(this).find("input[type=text]").val('');
			$(this).hide();
			$(this).after('<span class="thank_you">Thank you!</span>');
		} else {
			$(this).find("input[type=text]").val("Enter a valid e-mail address");
			$(this).find("input[type=text]").addClass("error");
		}
	});
});

var validateEmail = function(value) {  
	var regExp = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])","");
	return regExp.test(value);
}



/* Latest News - RSS Feed from Blog
--------------------------------------------------------------------------- */
$(function() {
	$("#rss-feed").rss("http://blog.shelterexchange.org/feed/", {
		limit: 4,
		template: "<ul>{entry}<li><h3><a href='{url}' target='_new'>{title} - {formattedDate}</a></h3>{shortBodyPlain}</li>{/entry}</ul>",	
  	  	tokens: {
	    	formattedDate: function(entry, tokens) { return Date.parse(tokens.date).toString("MMM d, yyyy"); }
	  	}
	});
});
