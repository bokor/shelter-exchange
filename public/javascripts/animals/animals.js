/*
	INDEX
*/
var Animals = {
	liveSearch: function(element,letters_before_search) {
		var element = $(element);
    	// element.down(".close").addClassName("busy");
		if (element.val().length >= letters_before_search) { // Require at least 3 letters before searching
			$.get("/animals/live_search", element.parents("form:first").serialize());
		}
  	},
	
	findByFilter: function(element){
		var element = $(element);
		$.get("/animals/find_by", element.parents("form:first").serialize());
	}
	
};

$(function() {
	$("#animal_primary_breed, #animal_secondary_breed").autocomplete({
		minLength: 3,
		selectFirst: true,
		html: true,
		delay: 300, //maybe 400
		// highlight: true, MAKE EXT LATER
		source: function( request, response ) {
			$.ajax({
				url: "/breeds/auto_complete",
				dataType: "json",
				data: {
					q: request.term,
					animal_type_id: $("#animal_animal_type_id").val()
				},
				success: function( data ) {
					response( $.map( data, function( item ) {
						var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
						var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
						return {
							label: item.label.replace(matcher,'<strong>$1</strong>'),
							value: item.value,
							id: item.id
						}  
					}));
				}
			});
		}			
	});			
});

// Animal List - Live Hover
// $("table.list tr").live('hover', function(event) {
//   if (event.type == 'mouseover') {
//     $(this).addClass("hover");
//   } else {
//     $(this).removeClass("hover");
//   }
// });



/*
	FORM
*/

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
});

$(function() {
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


$(function() {
	animalTypeSelected();
	showSecondaryBreed();
	$('#animal_animal_type_id').bind("click", function(event) {animalTypeSelected()});
	$('#animal_is_mix_breed').bind("click", function(event) {showSecondaryBreed()});
});

function animalTypeSelected() {
	var animal_type_id = $('#animal_animal_type_id').val();

	if (animal_type_id == '') {
		$('#primary_breed_field').hide();
		$('#secondary_breed_field').hide();
	} else {
		$('#primary_breed_field').show();
	}
}

function showSecondaryBreed() {
	var is_checked = $('#animal_is_mix_breed').is(':checked');
	if (is_checked) {
		$('#secondary_breed_field').show();
	} else {
		$('#secondary_breed_field').hide();
	}
}

/*
	SHOW
*/
$(function() {
	// Animal Show - Note Section - Filter Links
	$('#all_notes_link').addClass('active_link');
	$('#all_notes_link, #general_notes_link, #behavioral_notes_link, #medical_notes_link').click(function(event) {
		$('.active_link').removeClass('active_link');
		$(event.target).addClass('active_link');
	});

});






