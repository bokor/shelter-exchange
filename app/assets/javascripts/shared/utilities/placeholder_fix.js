/*!------------------------------------------------------------------------
 * shared/placeholder_fix.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* Placeholder Text for older browsers
/*----------------------------------------------------------------------------*/
$(function(){
    if ($("[placeholder]").length > 0){
        $('input, textarea').placeholder();
    }
});

