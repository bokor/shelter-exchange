/* ------------------------------------------------------------------------
 * transfers.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Transfers = {
	hasRequest: function(alreadyRequested) {
		if(alreadyRequested){
			$('#transfer_request_button').hide();
			$('#transfer_requested').removeClass("hide").addClass("show");
		} 
  	}
};