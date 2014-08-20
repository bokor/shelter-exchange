/*!------------------------------------------------------------------------
 * app/status_histories.js
 * ------------------------------------------------------------------------ */
var StatusHistories = {
	getComments: function(id){
		$.ajax({
			url: '/status_histories/' + id + '/comments.js',
			type: 'get',
			dataType: "script"
		});
	},
	selectContact: function(contact_id, contact_name) {
    $('.qtip').qtip('hide');

		var id = $('#status_history_id').val();
    if(id == "") {
      // If there is no status history id then we are using this
      // on the animal form so set the contact id and name
      Animals.addStatusHistoryContact(contact_id, contact_name);
    } else {
      $.ajax({
        url: '/status_histories/' + id + '.js',
        type: 'put',
        dataType: 'script',
        data: {
          status_history: {
            contact_id: contact_id
          }
        }
      });
    }
  },
	datePicker: function(element){
		$(element + " .date_picker").datepicker({
			numberOfMonths: 1,
			showButtonPanel: false,
			changeMonth: true,
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			altField: element + " .status_date_alt",
			altFormat: "D MM d, yy",
			onSelect: function(dateText,picker) {
				//HIDDEN FIELD
				$(element + " .hidden_status_date").val( dateText );

				//DIV FIELD
				var dateFormat = $(this).datepicker( "option", "dateFormat" );
				var altFormat = $(this).datepicker( "option", "altFormat" );
				var altField = $(this).datepicker( "option", "altField" );
				var parseDate = $.datepicker.parseDate(dateFormat, dateText);
				var formatDate = $.datepicker.formatDate(altFormat, parseDate);
				$(altField).html(formatDate);
			}
		});
	},
	cancelForm: function(id){
    event.preventDefault();

		$("#edit_status_history_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#status_history_"+id).fadeIn(1000);
	}
};

