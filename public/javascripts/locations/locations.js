var Locations = {
	findByFilter: function(element){
		var element = $(element);
		$.get("/locations/find_by", element.parents("form:first").serialize());
	}
	
};


$(function() {
    // $("#tokenize").tokenInput("http://loopj.com/tokeninput/tvshows.php", {
    //     hintText: "Type in the names of your favorite TV shows",
    //     noResultsText: "No results",
    //     searchingText: "Searching..."
    // });

    // $("#location_tag_list").tokenInput("/locations/find_tags", {
    //     classes: {
    //         tokenList: "token-input-list-facebook",
    //         token: "token-input-token-facebook",
    //         tokenDelete: "token-input-delete-token-facebook",
    //         selectedToken: "token-input-selected-token-facebook",
    //         highlightedToken: "token-input-highlighted-token-facebook",
    //         dropdown: "token-input-dropdown-facebook",
    //         dropdownItem: "token-input-dropdown-item-facebook",
    //         dropdownItem2: "token-input-dropdown-item2-facebook",
    //         selectedDropdownItem: "token-input-selected-dropdown-item-facebook",
    //         inputToken: "token-input-input-token-facebook"
    //     }
    // });
});

$(function() {
	$("#location_tag_list").autocomplete({
		minLength: 3,
		selectFirst: true,
		html: true,
		delay: 300, //maybe 400
		// highlight: true, MAKE EXT LATER
		source: function( request, response ) {
			$.ajax({
				url: "/locations/find_tags",
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
});
