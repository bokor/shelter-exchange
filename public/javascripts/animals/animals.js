var Animals = { 
	animalTypeSelected: function() {
		var animal_type_id = $('#animal_animal_type_id').val();

		if (animal_type_id == '') {
			$('#primary_breed_field').hide();
			$('#secondary_breed_field').hide();
			$('#accommodation_info').hide();
		} else {
			$('#primary_breed_field').show();
			$('#accommodation_info').show();
		}
	},
	animalStatusSelected: function(changed, animal_status_was) {
		var animal_status_id = $('#animal_animal_status_id').val();
		var has_value = $('#animal_status_history_reason').val() != "";
 
		if ((changed || has_value) && (animal_status_id != animal_status_was)) {
			$('#reason_field').show();
		} else {
			$('#reason_field').hide();
			$('#animal_status_history_reason').val("");
		}
	},
	showSecondaryBreed: function() {
		var is_checked = $('#animal_is_mix_breed').is(':checked');
		if (is_checked) {
			$('#secondary_breed_field').show();
		} else {
			$('#secondary_breed_field').hide();
			$('#secondary_breed_field').val("");
		}
	},
	formInitialize: function(is_kill_shelter, has_status_history_reason_error, animal_status_was) {
		Animals.autoComplete();
		Animals.animalTypeSelected();
		Animals.animalStatusSelected(has_status_history_reason_error, animal_status_was);
		Animals.showSecondaryBreed();
		Animals.showAccommodationRemoveLink();
		// Date of Birth DatePicker
		Animals.datePicker("#date_of_birth_datepicker", "#date_of_birth_humanize", '#animal_date_of_birth', true);
		Animals.setHumanizeDate('#date_of_birth', $('#animal_date_of_birth').val());
		$('#date_of_birth_trigger').bind("click", function(event) { $('#date_of_birth_datepicker').slideToggle();});
		// Bind Form Events
		$('#animal_animal_type_id').bind("change", function(event) {Animals.animalTypeSelected();});
		$('#animal_animal_status_id').bind("change", function(event) {Animals.animalStatusSelected(true, animal_status_was);});
		$('#animal_is_mix_breed').bind("click", function(event) {Animals.showSecondaryBreed();});
		$('#accommodation_search_link').bind("click",function(event) {Accommodations.filterByTypeLocation();});
		//Check if a kill shelter
		if(is_kill_shelter) {
			// Arrival Date initialize
			Animals.datePicker("#arrival_date_datepicker", "#arrival_date_humanize", '#animal_arrival_date', false);
			Animals.setHumanizeDate('#arrival_date', $('#animal_arrival_date').val());
			$('#arrival_date_trigger').bind("click", function(event) { $('#arrival_date_datepicker').slideToggle(); });
			// Euthanasia Date initialize
			Animals.datePicker("#euthanasia_scheduled_datepicker", "#euthanasia_scheduled_humanize", '#animal_euthanasia_scheduled', false);
			Animals.setHumanizeDate('#euthanasia_scheduled', $('#animal_euthanasia_scheduled').val());
			$('#euthanasia_scheduled_trigger').bind("click", function(event) { $('#euthanasia_scheduled_datepicker').slideToggle();});
		}
	},
	noteFilters: function(){
		$('#all_notes_link').addClass('active_link');
		$('#all_notes_link, #general_notes_link, #behavioral_notes_link, #medical_notes_link, #intake_notes_link').bind("click", function(event) {
			$('.active_link').removeClass('active_link');
			$(event.target).addClass('active_link');
		});
	},
	selectAccommodation: function(id, name) {
		$('#accommodation_selected span').html('<b>' + name + '</b>');
		$('#animal_accommodation_id').val(id);
		$('#accommodation_search_link').html("Change");
		$("#accommodation_remove_link").show();
		TopUp.close();
  	},
	removeAccommodation: function() {
		$('#accommodation_selected span').html('');
		$('#animal_accommodation_id').val('');
		$('#accommodation_search_link').html('Find');
		$('#accommodation_remove_link').hide();
	},
	showAccommodationRemoveLink: function() {
		var animal_accommodation_id = $('#animal_accommodation_id').val();
		if (animal_accommodation_id == '') {
			$('#accommodation_remove_link').hide();
		} else {
			$('#accommodation_remove_link').show();
		}
	},
	filterByTypeStatus: function(){
		$.get("/animals/filter_by_type_status.js", { 
			animal_type_id: $('#animal_animal_type_id').val(), 
			animal_status_id: $('#animal_animal_status_id').val() 
		});
	},
	// liveSearch: function(element){
	// 		var q = $(element);
	// 		if (q.val().length >= 3) {
	// 			clearTimeout($.data(element, "search_timer"));
	// 			var wait = setTimeout(function() { 
	// 				$.get("/animals/live_search.js", { q: q.val() });
	// 				clearTimeout($.data(element, "search_timer"));  
	// 			}, 500);
	// 			$.data(element, "search_timer", wait);
	// 		}
	// 	},
	autoComplete: function(){
		$("#animal_primary_breed, #animal_secondary_breed").autocomplete({
			minLength: 3,
			selectFirst: true,
			html: true,
			delay: 300, //maybe 400
			// highlight: true, MAKE EXT LATER
			source: function( request, response ) {
				$.ajax({
					url: "/breeds/auto_complete.json",
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
								label: item.name.replace(matcher,'<strong>$1</strong>'),
								value: item.name,
								id: item.id
							}  
						}));
					}
				});
			}			
		});
	},
	datePicker: function(datepickerId, altField, hiddenField, changeMonthYear){
		var changeYear = changeMonthYear;
		var changeMonth = changeMonthYear;
		$(datepickerId).datepicker({
			numberOfMonths: 1,
			showButtonPanel: false,
			changeMonth: changeMonth,
			changeYear: changeYear,
			dateFormat: 'yy-mm-dd',
			altField: altField,
			altFormat: "D MM d, yy",
			onSelect: function(dateText,picker) { 
				//HIDDEN FIELD
				$(hiddenField).val( dateText ); 

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
	setHumanizeDate: function(fieldName,dateVal){
		if(dateVal.length != 0){
			$(fieldName+'_datepicker').datepicker("setDate", dateVal);
			var tempDate = $(fieldName+'_datepicker').datepicker("getDate");
			var setDate = new Date(tempDate).toString('ddd MMMM dd, yyyy'); //DateJS formatting
			$(fieldName+'_humanize').html(setDate);
		}
	}
	
};