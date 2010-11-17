
// activation: string ("hover" by default) - jQuery method TipTip is activated with. Can be set to: "hover", "focus" or "click".
// keepAlive: true of false (false by default) - When set to true the TipTip will only fadeout when you hover over the actual TipTip and then hover off of it.
// maxWidth: string ("200px" by default) - CSS max-width property for the TipTip element. This is a string so you can apply a percentage rule or 'auto'.
// edgeOffset: number (3 by default) - Distances the TipTip popup from the element with TipTip applied to it by the number of pixels specified.
// defaultPosition: string ("bottom" by default) - Default orientation TipTip should show up as. You can set it to: "top", "bottom", "left" or "right".
// delay: number (400 by default) - Number of milliseconds to delay before showing the TipTip popup after you mouseover an element with TipTip applied to it.
// fadeIn: number (200 by default) - Speed at which the TipTip popup will fade into view.
// fadeOut: number (200 by default) - Speed at which the TipTip popup will fade out of view.
// attribute: string ("title" by default) - HTML attribute that TipTip should pull it's content from.
// content: string (false by default) - HTML or String to use as the content for TipTip. Will overwrite content from any HTML attribute.
// enter: callback function - Custom function that is run each time you mouseover an element with TipTip applied to it.
// exit: callback function - Custom function that is run each time you mouseout of an element with TipTip applied to it.
$(document).ready(function() {
	var tipTip = function(selector, options) {
		var elements = jQuery(selector);
    	elements.tipTip(options);    // apply tipTips as usual
    	$('body').ajaxComplete(function() {
    		elements = jQuery(selector); // reselect elements
        	elements.tipTip(options);   // and apply again after ajax requests
    	});
    	return elements;
	}

	tipTip("a[title]", {fadeIn:100, fadeOut: 100, delay:200, defaultPosition: "top", edgeOffset: 10});
});

