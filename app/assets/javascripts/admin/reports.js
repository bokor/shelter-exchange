/*!------------------------------------------------------------------------
 * admin/reports.js
 * ------------------------------------------------------------------------ */
var Reports = {
	initialize: function(){
		// Reload Report after Submit
		$('#submit_report').bind('click', function(){
			Reports.loadReports();
		});
		$('#submit_report').trigger('click');
	},
	loadReports: function(){
		var date_title = $("#_selected_month option:selected").html() + " " + $("#_selected_year option:selected").html();
		var status_by_month_year_title = 'Animals by Status Monthly Total - ' + date_title;
		Reports.pieChart(status_by_month_year_title, 'status_by_month_year');

		var type_by_month_year_title = 'Active Animals by Type Monthly Total - ' + date_title;
		Reports.pieChart(type_by_month_year_title, 'type_by_month_year');
	},
	pieChart: function(title, url_function){
		$.ajax({
			url: "/admin/reports/" + url_function + ".json",
			type: "get",
			dataType: 'json',
			data: {
				selected_month: $("#_selected_month").val(),
				selected_year: $("#_selected_year").val(),
				selected_state: $("#_selected_state").val()
			},
			success: function(data) {
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
		 	}
		});
	},
	barChart: function(title, url_function, yaxis_title){
		$.ajax({
			url: "/admin/reports/" + url_function + ".json",
			type: "get",
			dataType: 'json',
			data: {
				selected_month: $("#_selected_month").val(),
				selected_year: $("#_selected_year").val(),
				selected_state: $("#_selected_state").val()
			},
			success: function(data) {
				var options = {
					chart: { renderTo: url_function, defaultSeriesType: 'column' },
				    title: { text: title + ' - ' + $("#_selected_year").val() },
				    xAxis: {
				    	categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
				    },
				    yAxis: {
				    	min: 0,
				        title: { text: yaxis_title }
				    },
				    legend: { floating: false, shadow: false },
				    tooltip: {
				    	formatter: function() {
				        	return this.series.name + ': '+ this.y;
				        }
				   	},
				  	plotOptions: {
				   		column: { pointPadding: 0.2, borderWidth: 0 }
				   	},
				    series: []
				};

				$.each(data, function(i, item) {
					var series = {
						name: item.type,
						data: [item.jan,item.feb,item.mar,item.apr,item.may,item.jun,item.jul,item.aug,item.sep,item.oct,item.nov,item.dec]
					};
					options.series.push(series);
				});

				new Highcharts.Chart(options);
		 	}
		});
	}
};

