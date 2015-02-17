/*!------------------------------------------------------------------------
 * app/accommodations.js
 * ------------------------------------------------------------------------ */
var Accommodations = {
	search: function(){
		$.ajax({
			url: '/accommodations.js',
			type: 'get',
			dataType: 'script',
			data: {
				query: $('#query').val(),
				animal_type_id: $('#filters_animal_type_id').val(),
				location_id: $('#filters_location_id').val(),
        order_by: $('#filters_order_by').val()
			}
		});
	},
	cancelForm: function(id){
		$('#edit_accommodation_'+id).slideToggle(800,function() {
			$(this).remove();
		});
		$('#accommodation_'+id).fadeIn(1000);
	}
};

