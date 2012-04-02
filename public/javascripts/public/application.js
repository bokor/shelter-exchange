/*!------------------------------------------------------------------------
 * public/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
$(function() {

	$("header nav li").bind("click", function(e){
		window.location = $("a", this).attr("href");
	});
	
	// $(".flipboxes").bind("click", function(e){
	// 
	// 		if($(this).data('flipped')){
	// 			$(this).revertFlip();
	// 			$(this).data("flipped", false);
	// 		} else {
	// 			$(this).flip({
	// 				direction:'rl',
	// 				content:'this is my new content'
	// 			});
	// 			
	// 			$(this).data("flipped", true);
	// 		}
	// 		return false;
	// 	});
	// 	
	// 	<style type="text/css" media="screen">
	// 		.flipboxes {
	// 		width: 500px;
	// 		height: 200px;
	// 		line-height: 200px;
	// 		background-color: #FF9000;
	// 		font-family: 'ChunkFive Regular', Tahoma, Helvetica;
	// 		font-size: 2.5em;
	// 		color: white;
	// 		text-align: center;
	// 		margin-bottom: 20px;
	// 		}
	// 	</style>
	// 	<div id="flipbox" class="flipboxes" style="background-color: rgb(57, 171, 62); visibility: visible; ">
	// 		Hello! I'm a flip-box! :)
	// 	</div>
	// 	
	// 	<div id="flipbox" class="flipboxes" style="background-color: rgb(57, 171, 62); visibility: visible; ">
	// 		<%= image_tag("public/logos/logo-salesforce.gif")%>
	// 	</div>
	
	
	

});


/* Block UI - Setup and Config - Shows up if > than 400 ms
/*----------------------------------------------------------------------------*/ 
$(function() {
	var timer;
	
  	$(document).ajaxStart(function(){
  		timer = setTimeout(function(){
        	timer = null;
       		$("#main").block({
				message:  '<div class="ajax-message">' +
						  '<p><img src="/images/ajax-loader.gif" width="40" height="40" /></p>' +
						  '<h1>Loading . . .</h1>' +
						  '</div>',
				centerY: false, 
				showOverlay: false,
				css: {
			        padding:        		 '15px',
			        width:          		 '150px',
					height: 				 '90px',
			        top:                     ($(window).scrollTop() + 200) + 'px',
			        border:         		 '0px',
			        backgroundColor: 		 '#000',
					'-webkit-border-radius': '10px', 
			    	'-moz-border-radius':    '10px',
					'border-radius':         '10px',
					opacity:        		 0.7,
					color:          		 '#fff'
			    },
			    overlayCSS:  {
			        backgroundColor: 		 '#000',
			        opacity:         		 0.7
			    }
			});
     	}, 600);
 	}).ajaxStop( function() {
   		clearTimeout(timer);
       	timer = null;
    	$("#main").unblock();
	});
});

/* Pagination Links :: AJAX Searches
/*----------------------------------------------------------------------------*/
$('.pagination a').live('click',function (e){  
	e.preventDefault();
	var href = $(this).attr('href');
	$.getScript(href);  
});


/* Toggle Helper Links in Help a Shelter and Save a Life.
/*----------------------------------------------------------------------------*/
$(function() {
	$(".helper_links .toggle_buttons a").bind("click",function(e){
		e.preventDefault();
		$(this).toggleClass("current");
		var div = $(this).attr('href');
		$(div).slideToggle('slow');
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

var validateEmail = function(value) {  
	var regExp = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])","");
	return regExp.test(value);
}


/* You Tube Link Fancybox
/*----------------------------------------------------------------------------*/
$(function() {

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

});


/* Placeholder Text
/*----------------------------------------------------------------------------*/
$(function(){

	if(!Modernizr.input.placeholder){

		$('[placeholder]').focus(function() {
		  var input = $(this);
		  if (input.val() == input.attr('placeholder')) {
			input.val('');
			input.removeClass('placeholder');
		  }
		}).blur(function() {
		  var input = $(this);
		  if (input.val() == '' || input.val() == input.attr('placeholder')) {
			input.addClass('placeholder');
			input.val(input.attr('placeholder'));
		  }
		}).blur();
		$('[placeholder]').parents('form').submit(function() {
		  $(this).find('[placeholder]').each(function() {
			var input = $(this);
			if (input.val() == input.attr('placeholder')) {
			  input.val('');
			}
		  })
		});

	}
});


// href : youtube_url_parser($(this).attr("href")),
// title : $(this).attr("title"),

	// function youtube_url_parser(url){
	// 	var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\??v?=?))([^#\&\?]*).*/;
	//    	var match = url.match(regExp);
	//    	if (match&&match[7].length==11) {
	//    		return "http://www.youtube.com/v/" + match[7];
	//    	} else {
	//     	return url;
	//     }
	// }
	
/* Social Media - Facebook Like
/*----------------------------------------------------------------------------*/
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));


/* Social Media - Pintrest Pin it
/*----------------------------------------------------------------------------*/
(function() {
    window.PinIt = window.PinIt || { loaded:false };
    if (window.PinIt.loaded) return;
    window.PinIt.loaded = true;
    function async_load(){
        var s = document.createElement("script");
        s.type = "text/javascript";
        s.async = true;
        if (window.location.protocol == "https:")
            s.src = "https://assets.pinterest.com/js/pinit.js";
        else
            s.src = "http://assets.pinterest.com/js/pinit.js";
        var x = document.getElementsByTagName("script")[0];
        x.parentNode.insertBefore(s, x);
    }
    if (window.attachEvent)
        window.attachEvent("onload", async_load);
    else
        window.addEventListener("load", async_load, false);
})();


/* Social Media - Twitter Tweet
/*----------------------------------------------------------------------------*/
!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");

