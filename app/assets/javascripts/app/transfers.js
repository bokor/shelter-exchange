/*!------------------------------------------------------------------------
 * app/transfers.js
 * ------------------------------------------------------------------------ */
var Transfers = {
	hasRequest: function(alreadyRequested) {
		if(alreadyRequested){
			$('#transfer_request_button').hide();
			$('#transfer_requested').removeClass("hide").addClass("show");
		}
  	},
	cancelForm: function(id){
		$("#edit_transfer_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#transfer_"+id).fadeIn(1000);
	}
};

