/*!------------------------------------------------------------------------
 * admin/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */


/* ------------------------------------------------------------------------
 * Live - Hover, Click Events
 * ------------------------------------------------------------------------ */
$(function(){
	$(".counts_by_status, .users, .capacity_details tbody tr").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});
	
	/* Pagination Links :: AJAX Searches
	/*----------------------------------------------------------------------------*/
	$('.pagination a').live('click',function (e){  
		$.getScript(this.href);  
	    // return false;  
		e.preventDefault();
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