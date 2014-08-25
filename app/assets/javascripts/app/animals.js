/*!------------------------------------------------------------------------
 * app/animals.js
 * ------------------------------------------------------------------------ */
var Animals = {
	animalTypeSelected: function() {
		var animal_type_id = $('#animal_animal_type_id').val();

		if (animal_type_id == '') {
			$('#breed_fields').hide();
			$('.accommodation_info').hide();
		} else {
			$('#breed_fields').show();
			$('#primary_breed_field').show();
			$('.accommodation_info').show();
		}
	},
	animalStatusSelected: function(changed, animal_status_was) {
		var animal_status_id = $('#animal_animal_status_id').val();
		var has_value = $('#animal_status_history_reason').val() != "";

		if (animal_status_id != animal_status_was) {
			$('.status_history_section, .status_history_date_field, .status_history_reason_field, .status_history_contact_field').show();
		} else {
			$('.status_history_section, .status_history_date_field, .status_history_reason_field, .status_history_contact_field').hide();

      $('#animal_status_history_reason').val("");
			$('#animal_status_history_contact_id').val("");
			$('#contact_name').text("");
		}
	},
  addStatusHistoryContact: function(contact_id, contact_name){
    $('#animal_status_history_contact_id').val(contact_id);
    $('#contact_name').text($.trim(contact_name));
    $('#add_contact_link').hide();
    $('#remove_contact_link').show();
  },
  removeStatusHistoryContact: function(){
    $('#animal_status_history_contact_id').val("");
    $('#contact_name').empty();
    $('#add_contact_link').show();
    $('#remove_contact_link').hide();
  },
	specialNeedsSelected: function() {
		var hasSpecialNeeds = $('#animal_has_special_needs').is(':checked');

		if (hasSpecialNeeds) {
			$('#special_needs_field').show();
		} else {
			$('#special_needs_field').hide();
		}
	},
	showSecondaryBreed: function() {
		var isMixedBreed = $('#animal_is_mix_breed').is(':checked');
		if (isMixedBreed) {
			$('#secondary_breed_field').show();
		} else {
			$('#secondary_breed_field').hide();
			$('#secondary_breed_field').val("");
		}
	},
	formInitialize: function(is_kill_shelter, has_status_history_reason_error, animal_status_was) {
		Animals.autoComplete();
		Animals.animalTypeSelected();
		Animals.specialNeedsSelected();
		Animals.animalStatusSelected(has_status_history_reason_error, animal_status_was);
		Animals.showSecondaryBreed();
		Animals.showAccommodationRemoveLink();

    // Status History Date DatePicker
    Animals.datePicker("#animal_status_history_date");
    Animals.setDatePickerDate('#animal_status_history_date');
    $('#status_history_date_trigger').bind("click", function(event) { $('#animal_status_history_date_datepicker').slideToggle();});

		// Date of Birth DatePicker
		Animals.datePicker("#animal_date_of_birth");
		Animals.setDatePickerDate('#animal_date_of_birth');
		$('#date_of_birth_trigger').bind("click", function(event) { $('#animal_date_of_birth_datepicker').slideToggle();});

		// Bind Form Events
		$('#animal_animal_type_id').bind("change", function(event) {Animals.animalTypeSelected();});
		$('#animal_animal_status_id').bind("change", function(event) {Animals.animalStatusSelected(true, animal_status_was);});
		$('#animal_has_special_needs').bind("change", function(event) {Animals.specialNeedsSelected();});
		$('#animal_is_mix_breed').bind("click", function(event) {Animals.showSecondaryBreed();});
		$('#accommodation_search_link').bind("click",function(event) {Accommodations.filterByTypeLocation();});

		// Arrival Date initialize
		Animals.datePicker("#animal_arrival_date");
		Animals.setDatePickerDate('#animal_arrival_date');
		$('#arrival_date_trigger').bind("click", function(event) { $('#animal_arrival_date_datepicker').slideToggle(); });


		//Check if a kill shelter
		if(is_kill_shelter) {
			// Euthanasia Date initialize
			Animals.datePicker("#animal_euthanasia_date");
			Animals.setDatePickerDate('#animal_euthanasia_date');
			$('#euthanasia_date_trigger').bind("click", function(event) { $('#animal_euthanasia_date_datepicker').slideToggle();});
		}
	},
	selectAccommodation: function(id, name) {
		$('#accommodation_selected span').html('<b>' + name + '</b>');
		$('#animal_accommodation_id').val(id);
		$('#accommodation_search_link').html("Change");
		$("#accommodation_remove_link").show();
		//Hide QTip
		$('.qtip').qtip('hide');
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
		$.ajax({
			url: "/animals/filter_by_type_status.js",
			type: "get",
			dataType: 'script',
			data: {
				animal_type_id: $('#animal_animal_type_id').val(),
				animal_status_id: $('#animal_animal_status_id').val()
			}
		});
	},
	autoComplete: function(){
		$("#animal_primary_breed, #animal_secondary_breed").autocomplete({
			minLength: 3,
			autoFocus: true,
      selectFirst: true,
      delay: 500,
			source: function( request, response ) {
				$.ajax({
					url: "/shared/breeds/auto_complete.json",
					dataType: "json",
					data: {
						q: request.term,
						animal_type_id: $("#animal_animal_type_id").val()
					},
					success: function( data ) {
						response( $.map( data, function( item ) {
							return {
								label: item.name,
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
	},
	printInitialize: function(printLayout){
		$("input[name='print_layout']:radio").change(function(e){
			if($(this).val() == 'animal_with_notes'){
				$("#note_categories").find("input").prop("disabled","");
				$("#note_categories").find("label").css("color", "#222");
			} else {
				$("#note_categories").find("input").prop("disabled","disabled");
				$("#note_categories").find("label").css("color", "#bbb");
			}
		});
		$("input[value='"+printLayout+"']:radio").trigger("change").prop("checked", "checked");

		$('.print_format_options a').bind("click", function (e) {
			e.preventDefault();
			$("#print_format_options").slideToggle(800);
	  });
	}
};

