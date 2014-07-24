/*!------------------------------------------------------------------------
 * app/contacts.js
 * ------------------------------------------------------------------------ */
var Contacts = {
	filterByLastNameRole: function(){
		$.ajax({
			url: "/contacts/filter_by_last_name_role.js",
			type: "get",
			dataType: 'script',
			data: {
				by_last_name: $('#contact_by_last_name').val(),
				by_role: $('#contact_by_role').val()
			}
		});
	}
};

