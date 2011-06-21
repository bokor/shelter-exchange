/* ------------------------------------------------------------------------
 * comments.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

var Comments = {
	cancelForm: function(id){
		$("#edit_comment_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#comment_"+id).fadeIn(1000);
	}
};