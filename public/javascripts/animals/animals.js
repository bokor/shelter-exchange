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
	filterByType: function(element){
		var element = $(element);
		$.get("/animals/filter_by_type", element.parents("form:first").serialize());
	},
	selectLocation: function(id, name) {
		$('#location_selected span').html('<b>' + name + '</b>');
		$('#animal_location_id').val(id);
		$('#location_search_link').text("Change location");
		TopUp.close();
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

$(function() {
	animalTypeSelected();
	showSecondaryBreed();
	$('#animal_animal_type_id').bind("change", function(event) {animalTypeSelected()});
	$('#animal_is_mix_breed').bind("click", function(event) {showSecondaryBreed()});
	$('#location_search_link').bind("click",function(event) {updateLocationDetails()}); 
});

function animalTypeSelected() {
	var animal_type_id = $('#animal_animal_type_id').val();

	if (animal_type_id == '') {
		$('#primary_breed_field').hide();
		$('#secondary_breed_field').hide();
		$('#location_info').hide();
	} else {
		$('#primary_breed_field').show();
		$('#location_info').show();
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

function updateLocationDetails(){
	$.get("/locations/find_by", { animal_type_id: $('#animal_animal_type_id').val() } );
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






