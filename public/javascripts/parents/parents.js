
var Parents = {
	selectAnimal: function(id, name) {
		$('#animal_selected span').html('<b>' + name + '</b>');
		$('#placement_animal_id').val(id);
		$('#animal_search_link').text("Change animal");
		TopUp.close();
  	}
};



// $(document).ready(function() {
// 	$("#animal_name_auto_complete").autocomplete({
// 		minLength: 3,
// 		selectFirst: true,
// 		html: true,
// 		delay: 300, //maybe 400
// 		// highlight: true, MAKE EXT LATER
// 		source: function( request, response ) {
// 			$.ajax({
// 				url: "/animals/auto_complete",
// 				dataType: "json",
// 				data: {
// 					q: request.term
// 				},
// 				success: function( data ) {
// 					response( $.map( data, function( item ) {
// 						var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
// 						var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
// 						return {
// 							label: item.label.replace(matcher,'<strong>$1</strong>'),
// 							value: item.value,
// 							id: item.id
// 						}  
// 					}));
// 				}
// 			});
// 		},
// 		select: function(event, ui) {
// 			$("#parent_history_animal_id").val(ui.item.id);
// 		}			
// 	});			
// });