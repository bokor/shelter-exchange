/*!------------------------------------------------------------------------
 * shared/placeholder_fix.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */

/* Placeholder Text for older browsers
/*----------------------------------------------------------------------------*/ 
$(function(){
    if(!Modernizr.input.placeholder){
        $('input, textarea').placeholder();
    }
});


