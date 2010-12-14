var Parents = {
	selectAnimal: function(id, name) {
		$('#animal_selected span').html('<b>' + name + '</b>');
		$('#placement_animal_id').val(id);
		$('#animal_search_link').text("Change animal");
		TopUp.close();
  	}
};