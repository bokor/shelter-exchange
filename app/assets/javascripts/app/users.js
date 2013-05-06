/*!------------------------------------------------------------------------
 * app/users.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Users = {
	selectUser: function(id) {
		$.ajax({
			url: "/users/"+id+"/edit.js",
			type: "get",
			dataType: 'script'
		});
	},
	cancelForm: function(id){
		$("#edit_user_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#user_"+id).fadeIn(1000);
	}
};
