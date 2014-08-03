/*!------------------------------------------------------------------------
 * app/contacts.js
 * ------------------------------------------------------------------------ */
var Contacts = {
  updateSearchDialog: function(status_history_id){
    $('#form_contact_search #q').val('');
    $('#contacts').html('');
    $('#status_history_id').val(status_history_id);
  },
	filterByLastNameRole: function(){
		$.ajax({
			url: '/contacts/filter_by_last_name_role.js',
			type: 'get',
			dataType: 'script',
			data: {
				by_last_name: $('#filters_by_last_name').val(),
				by_role: $('#filters_by_role').val()
			}
		});
	},
  filterAnimalsByStatus: function(id){
		$.ajax({
			url: '/contacts/filter_animals_by_status.js',
			type: 'get',
			dataType: 'script',
			data: {
				id: id,
				by_status: $('#filters_by_status').val()
			}
		});
	}
};

