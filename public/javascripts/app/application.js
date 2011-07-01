/* ------------------------------------------------------------------------
 * app/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */




/* Block UI - Setup and Config
/*----------------------------------------------------------------------------*/

// Complex Block UI 
//    - Shows up if > than 400 ms
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
     	}, 400);
 	}).ajaxStop( function() {
   		clearTimeout(timer);
       	timer = null;
    	$("#left").unblock();
	});
});
// Simple Block UI 
//  - Shows up everytime
// $(function() { 
// 	$(document).ajaxStart($.blockUI);
// 	$(document).ajaxStop($.unblockUI);
// 
// });





/*
 * Application Stuff
 */

/* ------------------------------------------------------------------------
 * Live - Hover, Click Events
 * ------------------------------------------------------------------------ */
$(function(){
	$(".note, .status_history, .alert, .task, .location, .user").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
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





// Pagination Links -> AJAX Searches
$('.pagination a').live('click',function (){  
	$.getScript(this.href);  
    return false;  
});



//Sidebar Functions to Show and Hide them When Button is clicked
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

/* ------------------------------------------------------------------------
 * Toolbar Settings Menu
 * ------------------------------------------------------------------------ */
$(function () {
    $('.settings_link').bind("click", function (e) {
		$('ul.settings_menu').slideToggle("medium");
	    e.preventDefault();
    });
});

