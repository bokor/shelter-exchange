/*!------------------------------------------------------------------------
 * shared/pagination.js
 * ------------------------------------------------------------------------ */

/* Pagination Links :: AJAX Searches
/*----------------------------------------------------------------------------*/
$('.pagination a').live('click',function (e){
    e.preventDefault();
    var href = $(this).attr('href');
    $.getScript(href);
});

