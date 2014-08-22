/*!------------------------------------------------------------------------
 * shared/pagination.js
 * ------------------------------------------------------------------------ */

/* Pagination Links :: AJAX Searches
/*----------------------------------------------------------------------------*/
$(document).on('click', '.pagination a', function(e) {
    e.preventDefault();
    var href = $(this).attr('href').replace(".html", "");
    $.getScript(href);
});

