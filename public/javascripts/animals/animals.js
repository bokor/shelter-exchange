// document.observe('dom:loaded', function() {	
// 	$$(".hover_observer").each(function(element){
// 		element.up(1).observe("mouseout", function(e){
// 			element.toggle();
// 		});
// 		element.up(1).observe("mouseover", function(e){
// 			element.toggle();
// 		});
// 	});
// 
// });

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


// $(document).ready(function() {
// 	liveValidateForm();
// });
// function liveValidateForm() {
// 	// var sayHello = new LiveValidation("note_title", { validMessage: 'Hey there!', wait: 500});
// 	// sayHello.add(Validate.Presence, {failureMessage: "Don't just ignore me, I wanna be your friend!"});
// 	// sayHello.add(Validate.Format, {pattern: /^hello$/i, failureMessage: "How come you've not said 'hello' yet?" } );	
// }

$(document).ready(function() {
	$('#all_notes_link').addClass('active_link');
	
	$('#all_notes_link').bind("click", function(event) {updateNotesLink(event)});
	$('#general_notes_link').bind("click", function(event) {updateNotesLink(event)});
	$('#behavior_notes_link').bind("click", function(event) {updateNotesLink(event)});
	$('#medical_notes_link').bind("click", function(event) {updateNotesLink(event)});

});

function updateNotesLink(event) {
  $('.active_link').removeClass('active_link');
  $(event.target).addClass('active_link');
}