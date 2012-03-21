/*!------------------------------------------------------------------------
 * admin/reports.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Reports = {
	initialize: function(){
		// Load Report
		Reports.loadReports();
		
		// Reload Report after Submit
		$('#submit_report').bind('click', function(){
			Reports.loadReports();
		});
	},
	loadReports: function(){
		var date_title = $("#date_report_selected_month option:selected").html() + " " + $("#date_report_selected_year option:selected").html();
		var status_by_month_year_title = 'Animals by Status Monthly Total - ' + date_title;
		Reports.pieChart(status_by_month_year_title, 'status_by_month_year');
		
		var type_by_month_year_title = 'Active Animals by Type Monthly Total - ' + date_title;
		Reports.pieChart(type_by_month_year_title, 'type_by_month_year');
	},	
	pieChart: function(title, url_function){
		$.get('/admin/reports/' + url_function + '.json', { selected_month: $("#date_report_selected_month").val(), selected_year: $("#date_report_selected_year").val() },
			function(data) {
				var options = {
			    	chart: { renderTo: url_function },
			      	title: { text: title },
				  	plotArea: {
				  		shadow: null,
						borderWidth: null,
						backgroundColor: null
				   	},
					tooltip: {
						formatter: function() {
							return '<b>'+ this.point.name +' Total</b>: '+ this.y;
						}
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,
					  		cursor: 'pointer',
					     	dataLabels: { enabled: false },
					  		showInLegend: true
						}
					},
					series: [{
						type: 'pie',
						name: 'Type by Current Month',
						data: []
					}]
			   	};
			
				$.each(data, function(i, item) {
					var data = [item.name, item.count];
					options.series[0].data.push(data);
				});
					
				new Highcharts.Chart(options);
		 });
	}
};
