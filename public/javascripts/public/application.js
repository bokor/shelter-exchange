/*!------------------------------------------------------------------------
 * public/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
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


