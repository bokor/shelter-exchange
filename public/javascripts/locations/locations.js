var Locations = {
	findAllLocations: function() {
		$.get("/locations/find_all.js");
  	}, 
	closeEditLocationDialog: function(){
		Locations.findAllLocations();
		TopUp.close();
	}
};