/* ------------------------------------------------------------------------
 * app/parents.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Parents = {
	selectAnimal: function(id, name) {
		$('#animal_selected span').html('<b>' + name + '</b>');
		$('#placement_animal_id').val(id);
		$('#animal_search_link').text("Change animal");
		Tipped.hideAll();
  	}
};

// $(function() {
// 	$('.description').jTruncate({
// 		length: 100,
// 		minTrail: 0,
// 		moreText: "More",
// 		lessText: "Less"
// 	});
// });