/* ------------------------------------------------------------------------
 * users.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Users = {
	selectUser: function(id) {
		$.get("/users/"+id+"/edit.js");
	}
};

// $(function() {
// 	var user_name = new LiveValidation('user_name');
// 	user_name.add( Validate.Presence );	
// 	
// 	var user_email = new LiveValidation('user_email');
// 	user_email.add( Validate.Presence );
// 	user_email.add( Validate.Email );
// 	
// 	var user_role = new LiveValidation('user_role');
// 	user_role.add( Validate.Acceptance );
// });