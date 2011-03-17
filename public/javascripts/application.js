/*
 * Configure TopUp
 */
TopUp.images_path = "/images/top_up/";
TopUp.players_path = "/players/";


// Live List Hover
$(".note, .status_history, .location, .user").live('hover', function(event) {
  if (event.type == 'mouseover') {
    $(this).addClass("hover");
  } else {
    $(this).removeClass("hover");
  }
});

// Pagination Links -> AJAX Searches
$('.pagination a').live('click',function (){  
	$.getScript(this.href);  
    return false;  
});

// $(function() {
//   $(".pagination a").live("click", function() {
//     $.setFragment({ "page" : $.queryString(this.href).page })
//     $(".pagination").html("Page is loading...");
//     return false;
//   });
//   
//   $.fragmentChange(true);
//   $(document).bind("fragmentChange.page", function() {
//     $.getScript($.queryString(document.location.href, { "page" : $.fragment().page }));
//   });
//   
//   if ($.fragment().page) {
//     $(document).trigger("fragmentChange.page");
//   }
// });


//Sidebar Functions to Show and Hide them When Button is clicked
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

});





$(function(){

	//OnHover Show SubLevel Menus
	$('#secondary_nav ul li').hover(
		//OnHover
		function(){
			//Hide Other Menus
			$('#header ul li').not($('ul', this)).stop();

			//Add the Arrow
			$('ul li:first-child', this).before(
				'<li class="arrow"></li>'
			);

			//Remove the Border
			$('ul li.arrow', this).css('border-bottom', '0');

			// Show Hoved Menu
			$('ul', this).slideDown();
		},
		//OnOut
		function(){
			// Hide Other Menus
			$('ul', this).slideUp();

			//Remove the Arrow
			$('ul li.arrow', this).remove();
		}
	);

});