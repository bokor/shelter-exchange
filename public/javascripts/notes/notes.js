var Notes = {
	filters: function(){
		$('#all_notes_link').addClass('active_link');
		$('#all_notes_link, #general_notes_link, #behavioral_notes_link, #medical_notes_link, #intake_notes_link').bind("click", function(event) {
			$('.active_link').removeClass('active_link');
			$(event.target).addClass('active_link');
		});
	},
};