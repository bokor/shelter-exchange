/*!------------------------------------------------------------------------
 * public/home.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* Mission Statement :: Random Background Images
--------------------------------------------------------------------------- */
var HomePage = {
	randomizeImages: function(images){
		$('.mission_statement').css({'background': 'transparent url(' + images[Math.floor(Math.random() * images.length)] + ') no-repeat'});
	}
};

/* Home Page Slider
--------------------------------------------------------------------------- */
$(function() {
    $('#slider').nivoSlider({
		effect:'fade', // Specify sets like: 'fold,fade,sliceDown'
	    animSpeed:800, // Slide transition speed
        pauseTime:8000 // How long each slide will show
	});
});





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
