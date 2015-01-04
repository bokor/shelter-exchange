/*!------------------------------------------------------------------------
 * app/tasks.js
 * ------------------------------------------------------------------------ */
var offset;

var Tasks = {
	initialize: function(timezone_offset){
    offset = timezone_offset;

    Tasks.datePicker("#create_task");
		Tasks.dueDate("#create_task");
		$('#create_task .task_due_category').bind("change", function() {Tasks.dueDate("#create_task");});
	},
	removeTaskSection: function() {
		if ($("#overdue_tasks > div").size() == 0 && $('#overdue_tasks_section').is(":visible")) {
			$('#overdue_tasks_section').slideToggle();
		}
		if ($("#today_tasks > div").size() == 0 && $('#today_tasks_section').is(":visible")) {
			$('#today_tasks_section').slideToggle();
		}
		if ($("#tomorrow_tasks > div").size() == 0&& $('#tomorrow_tasks_section').is(":visible")) {
			$('#tomorrow_tasks_section').slideToggle();
		}
		if ($("#later_tasks > div").size() == 0 && $('#later_tasks_section').is(":visible")) {
			$('#later_tasks_section').slideToggle();
		}
	},
	dueDate: function(task_div) {
		var dueDate;
    var todayDate = Timezone.getDateWithOffset(offset);

		var due_category = $(task_div + ' .task_due_category').val();
		$(task_div + ' .due_date_field').parent().hide(); // Hide LI tag

		if (due_category == 'today') {
			dueDate = todayDate.toString('yyyy-MM-dd');
		} else if (due_category == 'tomorrow') {
			dueDate = todayDate.add(1).day().toString('yyyy-MM-dd');
		} else if (due_category == 'later') {
			dueDate = "";
		} else if (due_category == 'specific_date') {
			var datepickerDate = $(task_div + ' .date_picker').datepicker("getDate");
			dueDate = new Date.parse(datepickerDate, 'yyyy-MM-dd');
			$(task_div + ' .due_date_field').parent().show(); // Show LI tag
		}

		$(task_div + ' .hidden_due_date').val(dueDate);
	},
	datePicker: function(element){
		$(element + " .date_picker").datepicker({
			numberOfMonths: 1,
			showButtonPanel: false,
			changeMonth: true,
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			altField: element + " .due_date_alt",
			altFormat: "D MM dd, yy",
			onSelect: function(dateText,picker) {
				//HIDDEN FIELD
				$(element + " .hidden_due_date").val( dateText );

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
	complete: function(element, id){
		$(element).attr("disabled", true);
		if (confirm("Are you sure you want to complete this task? This task will no longer appear in the list.")) {
			$.ajax({
				url: "/tasks/"+id+"/complete.js",
				type: "post",
				dataType: 'script'
			});
		} else {
			$(element).attr("disabled", false);
			$(element).attr("checked", false);
		}
	},
	cancelForm: function(id){
		$("#edit_task_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#task_"+id).fadeIn(1000);
	}
};

