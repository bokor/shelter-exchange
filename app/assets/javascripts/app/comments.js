/*!------------------------------------------------------------------------
 * app/comments.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Comments = {
	initializeDialog: function(){
		$('.add_comment_link a').bind('click', function(e){
			e.preventDefault();
			$('#create_comment').slideToggle(800);
		});
		//$('.close_link a').bind('click', function(e){
		//	e.preventDefault();
			//Hide QTip
		//	$('.qtip.ui-tooltip').qtip('hide');
		//});
	},
	updateCommentable: function(id, commentable){
		$("#comment_commentable_id").val(id);
		$("#comment_commentable_type").val(commentable);
	},
	updateDialog: function(placement_shelter, current_shelter){
		$("#create_comment").hide();
		if(placement_shelter == current_shelter){
			$(".add_comment_link").show();
		} else {
			$(".add_comment_link").hide();
		}
	},
	cancelForm: function(id){
		$("#edit_comment_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#comment_"+id).fadeIn(1000);
	}
};