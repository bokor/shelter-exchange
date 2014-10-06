/*!------------------------------------------------------------------------
 * api/animals.js
 * ------------------------------------------------------------------------ */
var Animals = {
	filterInitialize: function(){
    Animals.bindFilters();
		Maps.breedAutoComplete(function(){Animals.findAnimalsForShelter()});
	},
	findAnimalsForShelter: function(){
    var version = $("#form_filters input[name='version']").val();
		$.ajax({
			url: "/" + version + "/animals/search.js",
			type: "get",
			dataType: "script",
			data: $("#form_filters").serialize()
		});
	},
	bindFilters: function(){

		$("#form_filters").bind("keypress", function(e){
			return !(window.event && window.event.keyCode == 13);
		});

		$("#filters_animal_type").bind("change", function(e){
			e.preventDefault();
			$("#filters_breed").val("");

			if($(this).val() == ""){
				$("#filters_breed").attr("disabled", true);
				$("#filters_breed").attr("placeholder", "Please select type first");
			} else {
				$("#filters_breed").attr("disabled", false);
				$("#filters_breed").attr("placeholder", "Enter Breed Name");
			}

			Animals.findAnimalsForShelter();
		});

    $('#filters_breed').keyup(function(){
      if(!$.trim(this.value).length){
        Animals.findAnimalsForShelter();
      }
    });

    // Enable breed auto complete when a type is already available
    if($("#filters_animal_type").val() != ""){
	    $("#filters_breed").attr("disabled", false);
			$("#filters_breed").attr("placeholder", "Enter Breed Name");
    }

		$("#filters_sex").bind("change", function(e){
			e.preventDefault();
			Animals.findAnimalsForShelter();
		});

		$("#filters_size").bind("change", function(e){
			e.preventDefault();
			Animals.findAnimalsForShelter();
		});

		$("#filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  	e.preventDefault();
			Animals.findAnimalsForShelter();
		});
	}
};

