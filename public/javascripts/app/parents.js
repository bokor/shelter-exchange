/*!------------------------------------------------------------------------
 * app/parents.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Parents = {
	selectAnimal: function(id, name) {
		$('#animal_selected').html(name);
		$('#placement_animal_id').val(id);
		$('#animal_search_link').text("Change animal");
		$('.qtip.ui-tooltip').qtip('hide');
  	}
};