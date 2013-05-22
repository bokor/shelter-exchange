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