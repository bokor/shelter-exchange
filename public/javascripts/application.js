/*
	Tipsy Tooltips for any A tag with rel="tipsy" added
*/
$(document).ready(function() {
	$('a[tooltip=tipsy]').tipsy({gravity: 's',offset: 10, opacity: 0.8});
});
