/*!------------------------------------------------------------------------
 * app/placements.js
 * ------------------------------------------------------------------------ */
var Placements = {
	findComments: function(id){
		$.ajax({
			url: "/placements/"+id+"/find_comments.js",
			type: "get",
			dataType: 'script'
		});
	},
	cancelForm: function(id){
		$("#placement_"+id).slideToggle(800,function() {
			$(this).remove();
		});
		$("#placement_"+id).fadeIn(1000);
	}
};

