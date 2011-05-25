/* ------------------------------------------------------------------------
 * animals.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Animals = { 
	animalTypeSelected: function() {
		var animal_type_id = $('#animal_animal_type_id').val();

		if (animal_type_id == '') {
			$('#breed_fields').hide();
			$('#accommodation_info').hide();
		} else {
			$('#breed_fields').show();
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
		Animals.datePicker("#animal_date_of_birth");
		Animals.setDatePickerDate('#animal_date_of_birth');
		$('#date_of_birth_trigger').bind("click", function(event) { $('#animal_date_of_birth_datepicker').slideToggle();});
		
		// Bind Form Events
		$('#animal_animal_type_id').bind("change", function(event) {Animals.animalTypeSelected();});
		$('#animal_animal_status_id').bind("change", function(event) {Animals.animalStatusSelected(true, animal_status_was);});
		$('#animal_is_mix_breed').bind("click", function(event) {Animals.showSecondaryBreed();});
		$('#accommodation_search_link').bind("click",function(event) {Accommodations.filterByTypeLocation();});
		
		//Check if a kill shelter
		if(is_kill_shelter) {
			// Arrival Date initialize
			Animals.datePicker("#animal_arrival_date");
			Animals.setDatePickerDate('#animal_arrival_date');
			$('#arrival_date_trigger').bind("click", function(event) { $('#animal_arrival_date_datepicker').slideToggle(); });
		
			// Euthanasia Date initialize
			Animals.datePicker("#animal_euthanasia_scheduled");
			Animals.setDatePickerDate('#animal_euthanasia_scheduled');
			$('#euthanasia_scheduled_trigger').bind("click", function(event) { $('#animal_euthanasia_scheduled_datepicker').slideToggle();});
		}
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
			delay: 500, //maybe 400
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
	datePicker: function(element){
		$(element + "_datepicker").datepicker({
			numberOfMonths: 1,
			showButtonPanel: false,
			changeMonth: true,
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			onSelect: function(dateText,picker) { 
				var dateFormat = $(element+'_datepicker').datepicker("option", "dateFormat");
				var tempDate = $.datepicker.parseDate(dateFormat, dateText);
				
				$(element+"_year").val($.datepicker.formatDate('yy', tempDate));
				$(element+"_month").val($.datepicker.formatDate('mm', tempDate));
				$(element+"_day").val($.datepicker.formatDate('dd', tempDate));

			}  
		});
	},
	setDatePickerDate: function(element){
		var year = $(element+"_year").val();
		var month = $(element+"_month").val();
		var day = $(element+"_day").val();
		var formatDate;
		if(year != "" && month != "" && day != ""){
			formatDate = $.datepicker.formatDate('yy-mm-dd', new Date(year, month-1, day));
		} else {
			formatDate = new Date().toString("yyyy-MM-dd");
		}
		$(element+'_datepicker').datepicker("setDate", formatDate);
	}
	
};