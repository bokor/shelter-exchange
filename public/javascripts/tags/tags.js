var Tags = {
	autoComplete: function(element){
		$(element).autocomplete({
			minLength: 3,
			selectFirst: true,
			html: true,
			delay: 300, //maybe 400
			// highlight: true, MAKE EXT LATER
			source: function( request, response ) {
				$.ajax({
					url: "/tags/auto_complete",
					dataType: "json",
					data: {
						q: request.term
					},
					success: function( data ) {
						response( $.map( data, function( item ) {
							var terms = request.term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1");
							var matcher = new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + terms + ")(?![^<>]*>)(?![^&;]+;)", "gi");
							return {
								label: item.label.replace(matcher,'<strong>$1</strong>'),
								value: item.value,
								id: item.id
							}  
						}));
					}
				});
			}			
		});
	}
	
};