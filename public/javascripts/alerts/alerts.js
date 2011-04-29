/* ------------------------------------------------------------------------
 * alerts.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Alerts = {
	removeAlertSection: function() {
		if ($("#shelter_alerts > div").size() == 0 && $('#shelter_alerts_section').is(":visible")) {  
			$('#shelter_alerts_section').slideToggle();
		} 
		if ($("#animal_alerts > div").size() == 0 && $('#animal_alerts_section').is(":visible")) { 
			$('#animal_alerts_section').slideToggle();
		}
	},
	stopped: function(element, id){
		$(element).attr("disabled", true);
		if (confirm("Are you sure you want to stop this alert? This alert will no longer appear in the list.")) { 
			$.get("/alerts/"+id+"/stopped.js");
		} else {
			$(element).attr("disabled", false);
			$(element).attr("checked", false);
		}
	}
};

