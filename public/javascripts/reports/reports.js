var Reports = {
	statusByCurrentYear: function(titleDate, renderLocation){
		$.get('/reports/status_by_current_year.json', 
			function(data) {
				new Highcharts.Chart({
			      	chart: { renderTo: renderLocation },
			      	title: { text: 'Animals by Status - ' + titleDate },
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
					     	dataLabels: { enabled: true },
					  			showInLegend: true
							}
						},
						series: [{
							type: 'pie',
							name: 'Browser share',
							data: data
						}]
			   		});
		 	});
	},
	statusByCurrentMonth: function(titleDate, renderLocation){
		$.get('/reports/status_by_current_month.json', 
			function(data) {
				new Highcharts.Chart({
			      	chart: { renderTo: renderLocation },
			      	title: { text: 'Animals by Status - ' + titleDate },
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
					     	dataLabels: { enabled: true },
					  			showInLegend: true
							}
						},
						series: [{
							type: 'pie',
							name: 'Browser share',
							data: data
						}]
			   		});
		 	});
	},
	typeByCurrentYear: function(titleDate, renderLocation){
		$.get('/reports/type_by_current_year.json', 
			function(data) {
				status_by_current_year = new Highcharts.Chart({
			      	chart: { renderTo: renderLocation },
			      	title: { text: 'Animals by Type - ' + titleDate },
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
					     	dataLabels: { enabled: true },
					  			showInLegend: true
							}
						},
						series: [{
							type: 'pie',
							name: 'Browser share',
							data: data
						}]
			   		});
		 	});
	},
	typeByCurrentMonth: function(titleDate, renderLocation){
		$.get('/reports/type_by_current_month.json', 
			function(data) {
				new Highcharts.Chart({
			      	chart: { renderTo: renderLocation },
			      	title: { text: 'Animals by Type - ' + titleDate },
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
					     	dataLabels: { enabled: true },
					  			showInLegend: true
							}
						},
						series: [{
							type: 'pie',
							name: 'Browser share',
							data: data
						}]
			   		});
		 	});
	},
	adoptionMonthlyTotalByType: function(element, renderLocation){
		$.get('/reports/adoption_monthly_total_by_type.json', { selected_year: $(element).val() },
			function(data) {
				var options = {
					chart: { renderTo: renderLocation, defaultSeriesType: 'column' },
				    title: { text: 'Adoption Monthly Total by Animal Type - ' + $(element).val() },
				    xAxis: {
				    	categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
				    },
				    yAxis: {
				    	min: 0,
				        title: { text: 'Adoptions' }
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
					var series = {};
					series.name = item.type;
					series.data = [item.jan,item.feb,item.mar,item.apr,item.may,item.jun,item.jul,item.aug,item.sep,item.oct,item.nov,item.dec];
					options.series.push(series);
				});
				
				new Highcharts.Chart(options);
		 	});
	},
	adoptionMonthlyTotal: function(element, renderLocation){
		$.get('/reports/adoption_monthly_total.json', { selected_year: $(element).val() },
			function(data) {
				var options = {
					chart: { renderTo: renderLocation, defaultSeriesType: 'column' },
				    title: { text: 'Adoption Monthly Total - ' + $(element).val() },
				    xAxis: {
				    	categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
				    },
				    yAxis: {
				    	min: 0,
				        title: { text: 'Adoptions' }
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
					var series = {};
					series.name = "Total";
					series.data = [item.jan,item.feb,item.mar,item.apr,item.may,item.jun,item.jul,item.aug,item.sep,item.oct,item.nov,item.dec];
					options.series.push(series);
				});
				
				new Highcharts.Chart(options);
		 	});
	},
	euthanasiaMonthlyTotalByType: function(element, renderLocation){
		$.get('/reports/euthanasia_monthly_total_by_type.json', { selected_year: $(element).val() },
			function(data) {
				var options = {
					chart: { renderTo: renderLocation, defaultSeriesType: 'column' },
				    title: { text: 'Euthanasia Monthly Total by Animal Type - ' + $(element).val() },
				    xAxis: {
				    	categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
				    },
				    yAxis: {
				    	min: 0,
				        title: { text: 'Euthanized' }
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
					var series = {};
					series.name = item.type;
					series.data = [item.jan,item.feb,item.mar,item.apr,item.may,item.jun,item.jul,item.aug,item.sep,item.oct,item.nov,item.dec];
					options.series.push(series);
				});
				
				new Highcharts.Chart(options);
		 	});
	},
	euthanasiaMonthlyTotal: function(element, renderLocation){
		$.get('/reports/euthanasia_monthly_total.json', { selected_year: $(element).val() },
			function(data) {
				var options = {
					chart: { renderTo: renderLocation, defaultSeriesType: 'column' },
				    title: { text: 'Euthanasia Monthly Total - ' + $(element).val() },
				    xAxis: {
				    	categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
				    },
				    yAxis: {
				    	min: 0,
				        title: { text: 'Euthanized' }
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
					var series = {};
					series.name = "Total";
					series.data = [item.jan,item.feb,item.mar,item.apr,item.may,item.jun,item.jul,item.aug,item.sep,item.oct,item.nov,item.dec];
					options.series.push(series);
				});
				
				new Highcharts.Chart(options);
		 	});
	}
};