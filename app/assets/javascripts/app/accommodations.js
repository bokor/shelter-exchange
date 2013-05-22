/*!------------------------------------------------------------------------
 * app/accommodations.js
 * ------------------------------------------------------------------------ */
var Accommodations = {
	filterByTypeLocation: function() {
		$.ajax({
			url: "/accommodations/filter_by_type_location.js",
			type: "get",
			dataType: 'script',
			data: {
				animal_type_id: $('#animal_animal_type_id').val(),
				location_id: $('#location_location_id').val()
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

