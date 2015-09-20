/*!------------------------------------------------------------------------
 * public/home.js
 * ------------------------------------------------------------------------ */

/* Mission Statement :: Random Background Images
--------------------------------------------------------------------------- */
var HomePage = {
  initialize: function(images){
    HomePage.loadSlider();
    HomePage.randomizeImages(images);
  },
	randomizeImages: function(images){
		$('.mission_statement').css({'background': 'transparent url(' + images[Math.floor(Math.random() * images.length)] + ') no-repeat'});
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

