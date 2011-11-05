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
	$.getScript(this.href);  
    // return false;  
	e.preventDefault();
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
	$(".shelter").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});
});

