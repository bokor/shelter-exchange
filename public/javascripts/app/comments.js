/* ------------------------------------------------------------------------
 * app/comments.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

var Comments = {
	updateCommentableDialog: function(id, commentable, placement_shelter, current_shelter){
		if(placement_shelter != current_shelter){
			$("#create_comment").hide();
		} else {
			$("#create_comment").show();
		}
		$("#comment_commentable_id").val(id);
		$("#comment_commentable_type").val(commentable);
	},
	cancelForm: function(id){
		$("#edit_comment_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#comment_"+id).fadeIn(1000);
	}
};