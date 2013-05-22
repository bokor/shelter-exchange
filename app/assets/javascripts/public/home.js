/*!------------------------------------------------------------------------
 * public/home.js
 * ------------------------------------------------------------------------ */

/* Mission Statement :: Random Background Images
--------------------------------------------------------------------------- */
var HomePage = {
  initialize: function(images){
    HomePage.loadSlider();
    HomePage.randomizeImages(images);
    HomePage.loadRSSFeed();
  },
	randomizeImages: function(images){
		$('.mission_statement').css({'background': 'transparent url(' + images[Math.floor(Math.random() * images.length)] + ') no-repeat'});
	},
	loadRSSFeed: function(){
	  /* Latest News - RSS Feed from Blog
    --------------------------------------------------------------------------- */
	  $("#rss-feed").rss("http://blog.shelterexchange.org/feed/", {
      limit: 4,
    	template: "<ul>{entry}<li><h3><a href='{url}' target='_new'>{title} - {formattedDate}</a></h3>{shortBodyPlain}</li>{/entry}</ul>",
      tokens: {
    	  formattedDate: function(entry, tokens) {
    	    return new Date(tokens.date).toString("MMM d, yyyy");
    	  }
      }
    });
	},
	loadSlider: function(){
    /* Home Page Slider
    --------------------------------------------------------------------------- */
    $('#slider').nivoSlider({
      effect:'fade', // Specify sets like: 'fold,fade,sliceDown'
      animSpeed:800, // Slide transition speed
      pauseTime:8000 // How long each slide will show
    });
	}
};

