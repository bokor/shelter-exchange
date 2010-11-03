// $(document).ready(function() {
// 	$("#animal_primary_breed, #animal_secondary_breed").autocomplete({
// 		minLength: 3,
// 		// maxLength: 15,
// 		// autoFill: true,
// 		fullSearch: true,
// 		selectFirst: true,
// 		html: true,
// 		// delay: 200,
// 		
// 		source: function( request, response ) {
// 			$.ajax({
// 				url: "/breeds/auto_complete",
// 				dataType: "json",
// 				data: {
// 					q: request.term,
// 					animal_type_id: $("#animal_animal_type_id").val()
// 				},
// 				success: function( data ) {
// 					response( $.map( data, function( item ) {
// 						return {
// 							label: item.label.replace(new RegExp("("+request.term.split(' ').join('|')+")", "gi"),'<b>$1</b>'),
// 							value: item.value.replace(new RegExp("("+request.term.split(' ').join('|')+")", "gi"),'<b>$1</b>')
// 						}  
// 					}));
// 				}
// 			});
// 		}			
// 	});			
// });

// $.post("test.php", { name: "John", time: "2pm" },
//    function(data){
//      alert("Data Loaded: " + data);
//    });


// jQuery(function( $ ){
//  
// // Bind click events to links. This will bind a click
// // handler to all current links as well as all new
// // links added to the page.
// $( "a" ).live(
// "click",
// function( event ){
// alert( "Link clicked!" );
// }
// );
//  
// });





/*
	INDEX
*/
var Animals = {
	liveSearch: function(element,letters_before_search) {
		var element = $(element);
    	// element.down(".close").addClassName("busy");
		if (element.val().length >= letters_before_search) { // Require at least 3 letters before searching
			$.get("/animals/live_search", element.parent("form").serialize());
		}
  	},
	
	findByFilter: function(element){
		var element = $(element);
		$.get("/animals/find_by", element.parents("form:first").serialize());
	}
	
};

$(document).ready(function() {
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
							value: item.value
						}  
					}));
				}
			});
		}			
	});			
});

/*
	FORM
*/
$(document).ready(function() {
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
$(document).ready(function() {
	// Animal Show - Note Section - Filter Links
	$('#all_notes_link').addClass('active_link');
	$('#all_notes_link, #general_notes_link, #behavior_notes_link, #medical_notes_link').click(function(event) {
		$('.active_link').removeClass('active_link');
		$(event.target).addClass('active_link');
	});
	// Animal Show - Sidebar - Form Show/Hide
	$('#add_alert_link, #cancel_alert').click(function() {
		$('#create_alert').slideToggle();
	});
	$('#add_note_link, #cancel_note').click(function() {
		$('#create_note').slideToggle();
	});

});
