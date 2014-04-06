/*!------------------------------------------------------------------------
 * app/notes.js
 * ------------------------------------------------------------------------ */
var Notes = {
	filters: function(){
		$('#all_notes_link').addClass('active_link');
		$('#all_notes_link, #general_notes_link, #behavioral_notes_link, #medical_notes_link, #intake_notes_link').bind("click", function(event) {
			$('.active_link').removeClass('active_link');
			$(event.target).addClass('active_link');
		});
	},
	cancelForm: function(id){
    event.preventDefault();

		$("#edit_note_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#note_"+id).fadeIn(1000);
	},
  refreshNote: function(id){
    $.ajax({
      url: "/notes/"+id+".js",
      type: "get",
   	  dataType: "script"
    });
  },
};

