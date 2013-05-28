/*!------------------------------------------------------------------------
 * app/capacities.js
 * ------------------------------------------------------------------------ */
var Capacities = {
	cancelForm: function(id){
		$('#edit_capacity_'+id).slideToggle(800,function() {
			$(this).remove();
		});
		$('#capacity_'+id).fadeIn(1000);
	}
};

