function removeAlertSection(){
	if ($("#shelter_alerts > div").size() == 0 && $('#shelter_alerts_section').is(":visible")) {  
		$('#shelter_alerts_section').slideToggle();
	} 
	if ($("#animal_alerts > div").size() == 0 && $('#animal_alerts_section').is(":visible")) { 
		$('#animal_alerts_section').slideToggle();
	}
}