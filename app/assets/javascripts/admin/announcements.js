/*!------------------------------------------------------------------------
 * app/announcements.js
 * ------------------------------------------------------------------------ */
var Announcements = {
	cancelForm: function(id){
		$("#edit_announcement_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#announcement_"+id).fadeIn(1000);
	}
};

