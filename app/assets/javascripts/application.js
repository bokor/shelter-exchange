//= require jquery.min
//= require jquery-ui.min
//= require jquery.ui.autocomplete
//= require jquery.qtip.min
//= require jquery.blockUI.min
//= require jquery.fancybox-1.3.4.pack
//= require jquery.jscroll.min
//= require jquery.placeholder.min
//= require tmpl.min
//= require jquery_fileupload/jquery.iframe-transport
//= require jquery_fileupload/jquery.fileupload
//= require jquery_fileupload/jquery.fileupload-ui
//= require jquery_fileupload/locale
//= require galleria-1.2.7.min
//= require galleria.twelve.min
//= require modernizr
//= require date
//= require jquery_ujs
//= require highcharts
//
//= require_tree ./shared/
//= require_tree ./app/


/* QTip - Tooltips
/*----------------------------------------------------------------------------*/
$(function() {
	//$.fn.qtip.zindex = 100;
	$('.tooltip').live('mouseover', function(event) {
    var width  = $(this).width();
    var height = $(this).height();

		$(this).qtip({
			overwrite: false,
			content: {
				text: function(api) { return $(this).attr('data-tip'); }
			},
			show: {
				event: event.type, // Use the same show event as the one that triggered the event handler
				ready: true // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
			},
			style: { classes: 'ui-tooltip-dark ui-tooltip-tipsy ui-tooltip-shadow' },
			position: {
				my: 'right center',
				adjust: { y: -(height/2), x:-(width) }
			}
		}, event).each(function(i) { // IE ONLY NOT SURE IF IT WORKS YET
			$.attr(this, 'oldtitle', $.attr(this, 'title'));
			this.removeAttribute('title');
		});
	});


	$('.tooltip_dialog').live('click', function(event) {
		event.preventDefault();
		$(this).qtip({
			overwrite: true,
			content: {
				text: $($(this).attr('data-dialog-element')),
				title: {
					text: $(this).attr('data-dialog-title'),
					button: true
				}
			},
			position: {
				my: 'center',
				at: 'center',
				target: $(window),
				adjust: { resize: true }
			},
			show: {
				event: event.type, // Use the same show event as the one that triggered the event handler
				ready: true, // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
				solo: true,
				modal: true
			},
			hide: false,
			style: {
				classes: 'ui-tooltip-dialog ui-tooltip-light ui-tooltip-rounded'
			},
			events: {
				blur: function(event, api) {
					var fn = api.elements.target.attr('data-dialog-blur');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				},
				show: function(event, api) {
					var fn = api.elements.target.attr('data-dialog-show');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				}
			}
		});
	});

	$('.photo_dialog, .document_dialog').live('click', function(event) {
		event.preventDefault();
		$(this).qtip({
			overwrite: false,
			content: {
				text: $($(this).attr('data-dialog-element')),
				title: {
					text: $(this).attr('data-dialog-title'),
					button: true
				}
			},
			position: {
				my: 'center',
				at: 'center',
				target: $(window),
				adjust: { resize: true }
			},
			show: {
				event: event.type, // Use the same show event as the one that triggered the event handler
				ready: true, // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
				solo: true,
				modal: true
			},
			hide: false,
			style: {
				classes: 'ui-tooltip-dialog ui-tooltip-light ui-tooltip-rounded'
			},
			events: {
				blur: function(event, api) {
					var fn = api.elements.target.attr('data-dialog-blur');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				},
				show: function(event, api) {
					var fn = api.elements.target.attr('data-dialog-show');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				}
			}
		});
	});
});


/* Live - Hover, Click Events
/*----------------------------------------------------------------------------*/
$(function(){
	$(".note, .status_history, .alert, .task, .location, .user").live('hover', function(e) {
	  if (e.type == 'mouseover' || e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});

	$(".alert, .note").live("click", function(e){
		var target = $(e.target);
        if(target.is("a") || target.is("input")) { //checks if other things are clicked first
            return;
        } else {
			$(".description", this).slideToggle();
		}
	});
	$(".user").live("click", function(e){
		var target = $(e.target);
        if(target.is("a") || target.is("input")) { //checks if other things are clicked first
            return;
        } else {
			// alert("select user");
			// Users.selectUser(<%=user.id%>);
		}
	});

});



/* Sidebar Function :: Show and Hide
/*----------------------------------------------------------------------------*/
$(function() {

	$('#add_alert_link, #cancel_alert').click(function() {
		$('#create_alert').slideToggle();
	});
	$('#add_note_link, #cancel_note').click(function() {
		$('#create_note').slideToggle();
	});
	$('#add_task_link, #cancel_task').click(function() {
		$('#create_task').slideToggle();
	});
	$('#add_placement_link, #cancel_placement').click(function() {
		$('#create_placement').slideToggle();
	});
	$('#add_capacity_link, #cancel_capacity').click(function() {
		$('#create_capacity').slideToggle();
	});
	$('#add_transfer_link, #cancel_transfer').click(function() {
		$('#create_transfer').slideToggle();
	});

});

/* Settings Menu :: Toolbar
/*----------------------------------------------------------------------------*/
$(function () {
    $('.settings_link').bind("click", function (e) {
		$('ul.settings_menu').slideToggle("medium");
	    e.preventDefault();
    });
});

