/*!------------------------------------------------------------------------
 * api/application.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
/* QTip - Tooltips
/*----------------------------------------------------------------------------*/
// $(function() {
// 	$('.tooltip-dialog').live('click', function(event) {
// 		event.preventDefault();
// 		$(this).qtip({
// 			overwrite: false,
// 			content: {
// 				text: $($(this).attr('data-dialog-element')),
// 				title: {
// 					text: $(this).attr('data-dialog-title'),
// 					button: true
// 				}
// 			},
// 			position: {
// 				my: 'center', 
// 				at: 'center',
// 				target: $(window),
// 				adjust: { resize: true }
// 			},
// 			show: {
// 				event: event.type, // Use the same show event as the one that triggered the event handler
// 				ready: true, // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
// 				solo: true, 
// 				modal: true 
// 			},
// 			hide: false,
// 			style: {
// 				classes: 'ui-tooltip-dialog ui-tooltip-light ui-tooltip-rounded'
// 			},
// 			events: {
// 				blur: function(event, api) {
// 					var fn = api.elements.target.attr('data-dialog-blur');
// 					if (typeof fn != 'undefined' && fn.length > 0) {
// 						eval(fn);
// 					} 
// 				}
// 			}
// 		});
// 	});		
// });