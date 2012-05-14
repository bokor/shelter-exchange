/* ------------------------------------------------------------------------
 * shared/forms.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
$(function() {
    /* ------------------------------------------------------------------------
     * Form Errors - Sets the correct class on the li tag of where the error is
     * ------------------------------------------------------------------------ */
     $("p.error").parents("li").addClass("error");
	
	
    /* ------------------------------------------------------------------------
     * Live Events Forms - set LI focused on the forms
     * ------------------------------------------------------------------------ */
    $("form li").live("focusin", function(){
		if (!$(this).hasClass('buttons')){
			$(this).addClass("focused");
		}
	});
	
	$("form li").live("focusout",function(){
		$(this).removeClass("focused");
	});
	
	$('input:radio, input:checkbox').live("click", function () {
	    this.blur();
	   	this.focus();
	});
	
});