/* ------------------------------------------------------------------------
 * admin/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */


/* ------------------------------------------------------------------------
 * Live - Hover, Click Events
 * ------------------------------------------------------------------------ */
$(function(){
	$(".counts_by_status").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});
	
	// $(".alert, .note").live("click", function(e){
	// 	var target = $(e.target);
	//         if(target.is("a") || target.is("input")) { //checks if other things are clicked first
	//             return;
	//         } else {
	// 		$(".description", this).slideToggle();
	// 	}
	// });
	// $(".user").live("click", function(e){
	// 	var target = $(e.target);
	//         if(target.is("a") || target.is("input")) { //checks if other things are clicked first
	//             return;
	//         } else {
	// 		// alert("select user");
	// 		// Users.selectUser(<%=user.id%>);
	// 	}
	// });
	
});