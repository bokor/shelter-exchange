/*!------------------------------------------------------------------------
 * shared/placeholder_fix.js
 * ------------------------------------------------------------------------ */

/* Placeholder Text for older browsers
/*----------------------------------------------------------------------------*/
$(function(){
  if ($("[placeholder]").length > 0){
    $('input, textarea').placeholder();
  }
});

