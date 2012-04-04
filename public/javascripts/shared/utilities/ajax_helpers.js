/*!------------------------------------------------------------------------
 * shared/ajax_helpers.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

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
