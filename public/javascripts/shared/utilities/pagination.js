/*!------------------------------------------------------------------------
 * shared/pagination.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* Pagination Links :: AJAX Searches   
/*----------------------------------------------------------------------------*/
$('.pagination a').live('click',function (e){  
    e.preventDefault();
    var href = $(this).attr('href');
    $.getScript(href);  
});