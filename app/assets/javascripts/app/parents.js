/*!------------------------------------------------------------------------
 * app/parents.js
 * ------------------------------------------------------------------------ */
var Parents = {
	selectAnimal: function(id, name) {
		$('#animal_selected').html(name);
		$('#placement_animal_id').val(id);
		$('#animal_search_link').text("Change animal");
		$('.qtip.ui-tooltip').qtip('hide');
  	}
};

