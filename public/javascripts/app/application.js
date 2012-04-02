/*!------------------------------------------------------------------------
 * app/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* QTip - Tooltips
/*----------------------------------------------------------------------------*/
$(function() {
	//$.fn.qtip.zindex = 100;
	$('.tooltip').live('mouseover', function(event) {
		$(this).qtip({
			overwrite: false,
			content: {
				text: function(api) { return $(this).attr('data-tip'); }
			},
			show: {
				event: event.type, // Use the same show event as the one that triggered the event handler
				ready: true // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
			},
			style: { classes: 'ui-tooltip-dark ui-tooltip-tipsy ui-tooltip-shadow' },
			position: {
				my: 'right center',
				adjust: { y: -10, x: -35 }
			}	
		}, event).each(function(i) { // IE ONLY NOT SURE IF IT WORKS YET
			$.attr(this, 'oldtitle', $.attr(this, 'title'));
			this.removeAttribute('title');
		});
	});

	
	$('.tooltip_dialog').live('click', function(event) {
		event.preventDefault();
		$(this).qtip({
			overwrite: true,
			content: {
				text: $($(this).attr('data-dialog-element')),
				title: {
					text: $(this).attr('data-dialog-title'),
					button: true
				}
			},
			position: {
				my: 'center', 
				at: 'center',
				target: $(window),
				adjust: { resize: true }
			},
			show: {
				event: event.type, // Use the same show event as the one that triggered the event handler
				ready: true, // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
				solo: true, 
				modal: true 
			},
			hide: false,
			style: {
				classes: 'ui-tooltip-dialog ui-tooltip-light ui-tooltip-rounded'
			},
			events: {
				blur: function(event, api) {
					var fn = api.elements.target.attr('data-dialog-blur');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					} 
				},
				show: function(event, api) {
					var fn = api.elements.target.attr('data-dialog-show');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					} 
				}
			}
		});
	});		
});






/* Block UI - Setup and Config - Shows up if > than 400 ms
/*----------------------------------------------------------------------------*/ 
$(function() {
	var timer;
	
  	$(document).ajaxStart(function(){
  		timer = setTimeout(function(){
        	timer = null;
       		$("#left").block({
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
     	}, 600); //changed from 400
 	}).ajaxStop( function() {
   		clearTimeout(timer);
       	timer = null;
    	$("#left").unblock();
	});
});


/* Live - Hover, Click Events
/*----------------------------------------------------------------------------*/
$(function(){
	$(".note, .status_history, .alert, .task, .location, .user").live('hover', function(e) {
	  if (e.type == 'mouseover') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});
	
	$(".alert, .note").live("click", function(e){
		var target = $(e.target);
        if(target.is("a") || target.is("input")) { //checks if other things are clicked first
            return;
        } else {
			$(".description", this).slideToggle();
		}
	});
	$(".user").live("click", function(e){
		var target = $(e.target);
        if(target.is("a") || target.is("input")) { //checks if other things are clicked first
            return;
        } else {
			// alert("select user");
			// Users.selectUser(<%=user.id%>);
		}
	});
	
});



/* Pagination Links :: AJAX Searches
/*----------------------------------------------------------------------------*/
$('.pagination a').live('click',function (e){  
	e.preventDefault();
	var href = $(this).attr('href');
	$.getScript(href);  
});



/* Sidebar Function :: Show and Hide
/*----------------------------------------------------------------------------*/
$(function() {

	$('#add_alert_link, #cancel_alert').click(function() {
		$('#create_alert').slideToggle();
	});
	$('#add_note_link, #cancel_note').click(function() {
		$('#create_note').slideToggle();
	});
	$('#add_task_link, #cancel_task').click(function() {
		$('#create_task').slideToggle();
	});
	$('#add_placement_link, #cancel_placement').click(function() {
		$('#create_placement').slideToggle();
	});
	$('#add_capacity_link, #cancel_capacity').click(function() {
		$('#create_capacity').slideToggle();
	});
	$('#add_transfer_link, #cancel_transfer').click(function() {
		$('#create_transfer').slideToggle();
	});

});

/* Settings Menu :: Toolbar
/*----------------------------------------------------------------------------*/
$(function () {
    $('.settings_link').bind("click", function (e) {
		$('ul.settings_menu').slideToggle("medium");
	    e.preventDefault();
    });
});


/* ------------------------------------------------------------------------
 * Utilities
 * ------------------------------------------------------------------------ */


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




