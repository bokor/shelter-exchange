/*!------------------------------------------------------------------------
 * shared/timezone.js
 * ------------------------------------------------------------------------ */
var Timezone = {
  getDateWithOffset: function(offset) {
    // create Date object for current location
    d = new Date();

    // convert to msec
    // add local time zone offset
    // get UTC time in msec
    utc = d.getTime() + (d.getTimezoneOffset() * 60000);

    // create new Date object for different city
    // using supplied offset
    return new Date(utc + (3600000*offset));
  }
};

