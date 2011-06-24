/* ------------------------------------------------------------------------
 * admin/accounts.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Accounts = {
	cancelForm: function(id){
		$("#edit_account_"+id).slideToggle(800,function() { 
			$(this).remove();
		});
		$("#account_"+id).fadeIn(1000);
	}
};

