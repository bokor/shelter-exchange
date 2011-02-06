var Reports = {
	statusByCurrentYear: function(titleDate, renderLocation){
		$.get('/reports/status_by_current_year', 
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
		$.get('/reports/status_by_current_month', 
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
		$.get('/reports/type_by_current_year', 
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
		$.get('/reports/type_by_current_month', 
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
	totalAdoptionsByTypeAndMonth: function(titleDate, renderLocation){
		$.get('/reports/total_adoptions_by_type_and_month', 
			function(data) {
				var options = {
					chart: { renderTo: renderLocation, defaultSeriesType: 'column' },
				    title: { text: 'Total Monthly Adoptions by Type - ' + titleDate },
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
	totalAdoptionsByMonth: function(titleDate, renderLocation){
		$.get('/reports/total_adoptions_by_month', 
			function(data) {
				var options = {
					chart: { renderTo: renderLocation, defaultSeriesType: 'column' },
				    title: { text: 'Total Monthly Adoptions - ' + titleDate },
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
	}
};