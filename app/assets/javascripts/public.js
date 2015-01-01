//= require jquery.min
//= require jquery-ui/jquery-ui.min
//= require jquery.ui.autocomplete
//= require jquery.blockUI.min
//= require nivo-slider/jquery.nivo.slider.pack
//= require jquery.rss_feed.min
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

var validateEmail = function(value) { return /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i.test(value); };

