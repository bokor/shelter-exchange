/*
 * Task Calendar Picker
 */
$(document).ready(function() {
	$("#create_task .date_picker").datepicker({
		numberOfMonths: 1,
		showButtonPanel: false,
		dateFormat: 'yy-mm-dd',
		altField: "#create_task .due_date_alt",
		altFormat: "D MM d, yy",
		onSelect: function(dateText,picker) { 
			//HIDDEN FIELD
			$('#create_task .hidden_due_date').val( dateText ); 
			
			//DIV FIELD
			var dateFormat = $(this).datepicker( "option", "dateFormat" );
			var altFormat = $(this).datepicker( "option", "altFormat" );
			var altField = $(this).datepicker( "option", "altField" );
			var parseDate = $.datepicker.parseDate(dateFormat, dateText);
			var formatDate = $.datepicker.formatDate(altFormat, parseDate);
			$(altField).html(formatDate);
			
		}  
	});
});

$(document).ready(function() {
	$('#create_task .hidden_due_date').val(Date.today().toString('yyyy-MM-dd'));
	$('#create_task .task_due_category').click(function() {dueDate("#create_task")});
});

function dueDate(task_div) {
	var setDate;
	var due_category = $(task_div + ' .task_due_category').val();
	$(task_div + ' .due_date_field').hide();
	
	if (due_category == 'today') {
		setDate = Date.today().toString('yyyy-MM-dd');
	} else if (due_category == 'tomorrow') { 
		setDate = new Date().add(1).day().toString('yyyy-MM-dd');
	} else if (due_category == 'later') { 
		setDate = "";
	} else if (due_category == 'specific_date') {
		var tempDate = $(task_div + ' .date_picker').datepicker("getDate");
		setDate = new Date(tempDate).toString('yyyy-MM-dd');
		$(task_div + ' .due_date_field').show();
	}
	
	$(task_div + ' .hidden_due_date').val(setDate);
}


