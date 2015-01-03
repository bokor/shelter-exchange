//= require jquery.min
//= require jquery-ui/jquery-ui.min
//= require jquery.ui.autocomplete
//= require qtip/jquery.qtip.min
//= require jquery.blockUI.min
//= require fancybox/jquery.fancybox-1.3.4.pack
//= require jquery.jscroll.min
//= require jquery.placeholder.min
//= require jquery-fileupload/tmpl.min
//= require jquery-fileupload/jquery.iframe-transport
//= require jquery-fileupload/jquery.fileupload
//= require jquery-fileupload/jquery.fileupload-ui
//= require jquery-fileupload/locale
//= require galleria/galleria-1.2.7.min
//= require galleria/galleria.twelve.min
//= require chosen.jquery.min
//= require modernizr
//= require date
//= require highcharts
//= require jquery_ujs
//
//= require_tree ./shared/
//= require_tree ./app/


/* QTip - Tooltips
/*----------------------------------------------------------------------------*/
$(function() {

  $(document).on('mouseover', '.tooltip', function(e) {
    var width  = $(this).width();
    var height = $(this).height();

		$(this).qtip({
			overwrite: false,
			content: {
				text: function(api) { return $(this).attr('data-tip'); }
			},
			show: {
				event: e.type, // Use the same show event as the one that triggered the event handler
				ready: true // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
			},
			style: { classes: 'qtip-tipsy' },
			position: {
        viewport: $(window),
				my: 'right center',
				adjust: { y: -(height/2), x:-(width) }
			}
		}, e).each(function(i) { // IE ONLY NOT SURE IF IT WORKS YET
			$.attr(this, 'oldtitle', $.attr(this, 'title'));
			this.removeAttribute('title');
		});
	});

  $(document).on('click', '.tooltip_dialog', function(e) {
		e.preventDefault();

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
				event: e.type, // Use the same show event as the one that triggered the event handler
				ready: true, // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
				solo: true,
        modal: true
			},
			hide: true,
			style: {
				classes: 'qtip-light qtip-rounded qtip-shadow qtip-dialog',
			},
			events: {
				blur: function(e, api) {
					var fn = api.elements.target.attr('data-dialog-blur');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				},
				show: function(e, api) {
					var fn = api.elements.target.attr('data-dialog-show');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				}
			}
		}, e).removeData('qtip');
	});

  $(document).on('click', '.photo_dialog, .document_dialog', function(e) {
		e.preventDefault();

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
				event: e.type, // Use the same show event as the one that triggered the event handler
				ready: true, // Show the tooltip as soon as it's bound, vital so it shows up the first time you hover!
				solo: true,
				modal: true
			},
			hide: false,
			style: {
				classes: 'qtip-light qtip-rounded qtip-shadow qtip-dialog'
			},
			events: {
				blur: function(e, api) {
					var fn = api.elements.target.attr('data-dialog-blur');
					if (typeof fn != 'undefined' && fn.length > 0) {
						eval(fn);
					}
				},
				show: function(e, api) {
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
	$(".note, .status_history, .task, .location, .user").live('hover', function(e) {
	  if (e.type == 'mouseover' || e.type == 'mouseenter') {
	    $(this).addClass("hover");
	  } else {
	    $(this).removeClass("hover");
	  }
	});

	$(".note").live("click", function(e){
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
		}
	});

});

/* Sidebar Function :: Show and Hide
/*----------------------------------------------------------------------------*/
$(function() {

	$('#add_note_link, #cancel_note').click(function() {
		$('#create_note').slideToggle();
	});
	$('#add_task_link, #cancel_task').click(function() {
		$('#create_task').slideToggle();
	});
	$('#add_capacity_link, #cancel_capacity').click(function() {
		$('#create_capacity').slideToggle();
	});
	$('#add_transfer_link, #cancel_transfer').click(function() {
		$('#create_transfer').slideToggle();
	});
	$('#import_contacts_link, #cancel_contact_import').click(function() {
		$('#import_contacts').slideToggle();
	});
	$('#export_contacts_link, #cancel_contact_export').click(function() {
		$('#export_contacts').slideToggle();
	});
  $('#export_animals_link, #cancel_animal_export').click(function() {
		$('#export_animals').slideToggle();
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

