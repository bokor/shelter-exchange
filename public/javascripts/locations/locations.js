/* ------------------------------------------------------------------------
 * locations.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Locations = {
	findAllLocations: function() {
		$.get("/locations/find_all.js");
  	}
};