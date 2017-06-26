//= require jquery.min
//= require jquery-ui/jquery-ui.min
//= require jquery.ui.autocomplete
//= require jquery.blockUI.min
//= require nivo-slider/jquery.nivo.slider.pack
//= require fancybox/jquery.fancybox-1.3.4.pack
//= require jquery.jscroll.min
//= require jquery.placeholder.min
//= require galleria/galleria-1.2.7.min
//= require galleria/galleria.twelve.min
//= require chosen.jquery.min
//= require modernizr
//= require date
//= require jquery_ujs
//
//= require_tree ./shared/
//= require_tree ./public/

$(function() {

	$("header nav li").bind("click", function(e){
		window.location = $("a", this).attr("href");
	});

});


/* Check application for classes that needs hovered
/*----------------------------------------------------------------------------*/
$(function() {
	$(".shelter, .animal").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});
});

