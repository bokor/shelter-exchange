//= require jquery.min
//= require jquery-ui/jquery-ui.min
//= require jquery.ui.autocomplete
//= require jquery.blockUI.min
//= require modernizr
//= require date
//= require highcharts
//= require jquery_ujs
//
//= require_tree ./shared/
//= require_tree ./admin/

/* Live - Hover, Click Events
/*----------------------------------------------------------------------------*/
$(function(){

	$(".announcement, .counts_by_status, .users, .capacity_details tbody tr").live('hover', function(e) {
	  if (e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});

	$(".announcement").live("click", function(e){
		var target = $(e.target);
	    if(target.is("a") || target.is("input")) { //checks if other things are clicked first
	        return;
	    } else {
			$(".message", this).slideToggle();
		}
	});

});

