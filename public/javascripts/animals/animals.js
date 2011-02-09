var Animals = {
	filterByTypeStatus: function(){
		$.get("/animals/filter_by_type_status", { 
				animal_type_id: $('#animal_animal_type_id').val(), 
				animal_status_id: $('#animal_animal_status_id').val() 
		});
	},
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
	showSecondaryBreed: function() {
		var is_checked = $('#animal_is_mix_breed').is(':checked');
		if (is_checked) {
			$('#secondary_breed_field').show();
		} else {
			$('#secondary_breed_field').hide();
		}
	},
	formInitialize: function() {
		Animals.animalTypeSelected();
		Animals.showSecondaryBreed();
		Animals.showAccommodationRemoveLink();
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

	
$(function() {
	$('#animal_animal_type_id').bind("change", function(event) {Animals.animalTypeSelected()});
	$('#animal_is_mix_breed').bind("click", function(event) {Animals.showSecondaryBreed()});
	$('#accommodation_search_link').bind("click",function(event) {Accommodations.filterByTypeLocation()}); 
	
	// Animal Show - Note Section - Filter Links
	$('#all_notes_link').addClass('active_link');
	$('#all_notes_link, #general_notes_link, #behavioral_notes_link, #medical_notes_link').bind("click", function(event) {
		$('.active_link').removeClass('active_link');
		$(event.target).addClass('active_link');
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

// $(function() {
	// animalTypeSelected();
	// showSecondaryBreed();
	// showAccommodationRemoveLink();
// });
// function animalTypeSelected() {
// 	var animal_type_id = $('#animal_animal_type_id').val();
// 
// 	if (animal_type_id == '') {
// 		$('#primary_breed_field').hide();
// 		$('#secondary_breed_field').hide();
// 		$('#accommodation_info').hide();
// 	} else {
// 		$('#primary_breed_field').show();
// 		$('#accommodation_info').show();
// 	}
// }

// function showSecondaryBreed() {
// 	var is_checked = $('#animal_is_mix_breed').is(':checked');
// 	if (is_checked) {
// 		$('#secondary_breed_field').show();
// 	} else {
// 		$('#secondary_breed_field').hide();
// 	}
// }
// 
// function showAccommodationRemoveLink() {
// 	var animal_accommodation_id = $('#animal_accommodation_id').val();
// 	if (animal_accommodation_id == '') {
// 		$('#accommodation_remove_link').hide();
// 	} else {
// 		$('#accommodation_remove_link').show();
// 	}
// }






