/* ------------------------------------------------------------------------
 * global/forms.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */


/* ------------------------------------------------------------------------
 * Form Errors - Sets the correct class on the li tag of where the error is
 * ------------------------------------------------------------------------ */
$(function(){
	$("p.error").parents("li").addClass("error");
});

// Focuses the first text field on every page
// $(function(){
//    var el = $(':text:eq(0)');
//    el.focus();
// });

/* ------------------------------------------------------------------------
 * Live Events Forms - set LI focused on the forms
 * ------------------------------------------------------------------------ */
$(function() {

	$("form li").live("focusin", function(){
		if (!$(this).hasClass('buttons')){
			$(this).addClass("focused");
		}
	});
	
	$("form li").live("focusout",function(){
		$(this).removeClass("focused");
	});
	
	// if ($.browser.webkit || $.browser.msie) {
		$('input:radio, input:checkbox').live("click", function () {
	   		this.blur();
	   		this.focus();
		});
	// }

});