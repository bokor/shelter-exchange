/*
 * Task Calendar Picker
 */
$(document).ready(function() {
	$("#date_picker").datepicker({
		numberOfMonths: 1,
		showButtonPanel: false,
		dateFormat: 'yy-mm-dd',
		altField: "#due_date_alt",
		altFormat: "D MM d, yy",
		onSelect: function(dateText,picker) { 
			
			//HIDDEN FIELD
			$('#task_due_date').val( dateText ); 
			
			//DIV FIELD
			var dateFormat = $( "#date_picker" ).datepicker( "option", "dateFormat" );
			var altFormat = $( "#date_picker" ).datepicker( "option", "altFormat" );
			var altField = $( "#date_picker" ).datepicker( "option", "altField" );
			var parseDate = $.datepicker.parseDate(dateFormat, dateText);
			var formatDate = $.datepicker.formatDate(altFormat, parseDate);
			$(altField).html(formatDate);
			
		}  
	});
});

$(document).ready(function() {
	$('#task_due_category').click(function() {dueDate()});
	function dueDate() {
		var setDate;
		var due_category = $('#task_due_category').val();
		$('#due_date_field').hide();
		
		if (due_category == 'today') {
			setDate = Date.today().toString('yyyy-MM-dd');
		} else if (due_category == 'tomorrow') { 
			setDate = new Date().add(1).day().toString('yyyy-MM-dd');
		} else if (due_category == 'later') { 
			setDate = "";
		} else if (due_category == 'specific_date') {
			var tempDate = $("#date_picker").datepicker("getDate");
			setDate = new Date(tempDate).toString('yyyy-MM-dd');
			$('#due_date_field').show();
		}
		
		$('#task_due_date').val(setDate);
	}
});


