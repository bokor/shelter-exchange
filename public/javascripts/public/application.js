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

