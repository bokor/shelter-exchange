$(function() {
	$("#arrival_date_datepicker").datepicker({
		numberOfMonths: 1,
		showButtonPanel: false,
		dateFormat: 'yy-mm-dd',
		altField: "#arrival_date_humanize",
		altFormat: "D MM d, yy",
		onSelect: function(dateText,picker) { 
			//HIDDEN FIELD
			$('#animal_arrival_date').val( dateText ); 

			//DIV FIELD
			var dateFormat = $(this).datepicker( "option", "dateFormat" );
			var altFormat = $(this).datepicker( "option", "altFormat" );
			var altField = $(this).datepicker( "option", "altField" );
			var parseDate = $.datepicker.parseDate(dateFormat, dateText);
			var formatDate = $.datepicker.formatDate(altFormat, parseDate);
			$(altField).html(formatDate);

		}  
	});

	$("#euthanasia_scheduled_datepicker").datepicker({
		numberOfMonths: 1,
		showButtonPanel: false,
		dateFormat: 'yy-mm-dd',
		altField: "#euthanasia_scheduled_humanize",
		altFormat: "D MM d, yy",
		onSelect: function(dateText,picker) { 
			//HIDDEN FIELD
			$('#animal_euthanasia_scheduled').val( dateText ); 

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

$(function() {

	var animal_arrival_date = $('#animal_arrival_date').val();
	setHumanizeDate('#arrival_date', animal_arrival_date);
	
	var animal_euthanasia_scheduled = $('#animal_euthanasia_scheduled').val();
	setHumanizeDate('#euthanasia_scheduled', animal_euthanasia_scheduled);

	
	function setHumanizeDate(fieldName,dateVal){
		if(dateVal.length != 0){
			$(fieldName+'_datepicker').datepicker("setDate", dateVal);
			var tempDate = $(fieldName+'_datepicker').datepicker("getDate");
			var setDate = new Date(tempDate).toString('ddd MMMM dd, yyyy'); //DateJS formatting
			$(fieldName+'_humanize').html(setDate);
		}
	}

});

$(function() {
    $('#arrival_date_trigger').click(function() {
        $('#arrival_date_datepicker').slideToggle();
    });
	$('#euthanasia_scheduled_trigger').click(function() {
        $('#euthanasia_scheduled_datepicker').slideToggle();
    });
});
