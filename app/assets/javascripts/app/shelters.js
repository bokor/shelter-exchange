/*!------------------------------------------------------------------------
 * app/shelters.js
 * ------------------------------------------------------------------------ */
var Shelters = {
	initialize: function(lat, lng, s3_url){
		Shelters.loadMap(lat, lng, s3_url);
		Shelters.bindWishList();
	},
	loadMap: function(lat, lng, s3_url){
	  var myLatLng = new google.maps.LatLng(lat,lng);
	  var myOptions = {
	    zoom: 13,
	    center: myLatLng,
		  scrollwheel: false,
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	  }

    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	  var marker = new google.maps.Marker({
		  center: myLatLng,
		  position: myLatLng,
		  map: map,
		  icon: s3_url,
      clickable: false,
	    draggable: false
	  });
	},
	bindWishList: function(){
		$("#edit_wish_list").bind("click", function(){
			$(this).hide();
		});
	}
};

