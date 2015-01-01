/*!------------------------------------------------------------------------
 * api/animals.js
 * ------------------------------------------------------------------------ */
var Animals = {
	filterInitialize: function(){
    Animals.bindFilters();

    // Bind to chosen change
    $("#filters_breed").chosen().change(function(e, params){
      Animals.findAnimalsForShelter();
    });

    // Resize Chosen to be fluid
    $('.chosen-container').each(function (index) {
      $(this).css({
        'min-width': '100%',
        'max-width': '100%'
      });
    });
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
      var animalTypeId = $(this).val();
			$("#filters_breed").val("");

			if(animalTypeId == ""){
        $("#filters_breed").empty();
        $("#filters_breed").prepend("<option/>");
        $("#filters_breed").attr('disabled', true);
        $("#filters_breed").attr('data-placeholder', "Please select type first");

        $(".chosen-select").trigger("chosen:updated");
			} else {
        $("#filters_breed").attr('disabled', false);
        $("#filters_breed").attr('data-placeholder', "Type animal breed");
        Breeds.updateChosenByType(animalTypeId, '#filters_breed');

        $(".chosen-select").trigger("chosen:updated");
			}

		  Animals.findAnimalsForShelter();
			e.preventDefault();
		});

    $('#filters_breed').keyup(function(){
      if(!$.trim(this.value).length){
        Animals.findAnimalsForShelter();
      }
    });

    if($("#filters_animal_type").val() != ""){
      $("#filters_breed").attr('disabled', false);
      $("#filters_breed").attr('data-placeholder', "Type animal breed");
      Breeds.updateChosenByType(animalTypeId, '#filters_breed');

      $(".chosen-select").trigger("chosen:updated");
    }

		$("#filters_sex, #filters_size").bind("change", function(e){
			e.preventDefault();
			Animals.findAnimalsForShelter();
		});

		$("#filters_special_needs_only").bind($.browser.msie? "propertychange" : "change", function(e) {
		  	e.preventDefault();
			Animals.findAnimalsForShelter();
		});
	}
};

