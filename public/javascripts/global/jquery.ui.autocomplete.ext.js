/*
 * jQuery UI Autocomplete HTML Extension
 *
 */
(function( $ ) {

	$.extend( $.ui.autocomplete.prototype, {
		_renderItem: function( ul, item ) {
			var matcher = new RegExp("("+$.ui.autocomplete.escapeRegex(this.element.val())+")", "ig" );
			var label = item.label.replace( matcher, "<strong>$1</strong>" ); //.replace(matcher,'<strong>$1</strong>')
		    return $( "<li></li>" )
		    	.data( "item.autocomplete", item )
		        .append( $("<a></a>").html(label) )
		        .appendTo( ul );
		}
	});

})( jQuery );


// (function( $ ) {
// 
// var proto = $.ui.autocomplete.prototype,
// 	initSource = proto._initSource;
// 
// function filter( array, term ) {
// 	var matcher = new RegExp( $.ui.autocomplete.escapeRegex(term), "i" );
// 	return $.grep( array, function(value) {
// 		return matcher.test( $( "<div>" ).html( value.label || value.value || value ).text() );
// 	});
// }
// 
// $.extend( proto, {
// 	_initSource: function() {
// 		if ( this.options.html && $.isArray(this.options.source) ) {
// 			this.source = function( request, response ) {
// 				response( filter( this.options.source, request.term ) );
// 			};
// 		} else {
// 			initSource.call( this );
// 		}
// 	},
// 
// 	_renderItem: function( ul, item) {
// 		return $( "<li></li>" )
// 			.data( "item.autocomplete", item )
// 			.append( $( "<a></a>" )[ this.options.html ? "html" : "text" ]( item.label ) )
// 			.appendTo( ul );
// 	}
// });
// 
// })( jQuery );