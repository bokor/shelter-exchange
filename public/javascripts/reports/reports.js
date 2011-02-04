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
	}
};