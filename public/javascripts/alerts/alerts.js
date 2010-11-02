$(document).ready(function() {
	var dates = $("#alert_start_date, #alert_end_date").datepicker({
		numberOfMonths: 2,
		showButtonPanel: false,
		dateFormat: 'yy-mm-dd',
		onSelect: function( selectedDate ) {
			var option = this.id == "alert_start_date" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" );
				date = $.datepicker.parseDate(
					instance.settings.dateFormat ||
					$.datepicker._defaults.dateFormat,
					selectedDate, instance.settings );
			dates.not( this ).datepicker( "option", option, date );
		}
	});
});