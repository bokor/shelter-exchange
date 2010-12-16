
var chart1;
$(function() {
	chart1 = new Highcharts.Chart({
		chart: {
			renderTo: 'report_test',
			defaultSeriesType: 'area'
		},
		title: {
			text: 'Historic and Estimated Worldwide Population Distribution by Region'
		},
		subtitle: {
			text: 'Source: Wikipedia.org'
		},
		xAxis: {
			categories: ['1750', '1800', '1850', '1900', '1950', '1999', '2050'],
			tickmarkPlacement: 'on',
			title: {
				enabled: false
			}
		},
		yAxis: {
			title: {
				text: 'Percent'
			}
		},
		tooltip: {
			formatter: function() {
	                return ''+
					 this.x +': '+ Highcharts.numberFormat(this.percentage, 1) +'% ('+
					 Highcharts.numberFormat(this.y, 0, ',') +' millions)';
			}
		},
		plotOptions: {
			area: {
				stacking: 'percent',
				lineColor: '#ffffff',
				lineWidth: 1,
				marker: {
					lineWidth: 1,
					lineColor: '#ffffff'
				}
			}
		},
		series: [{
			name: 'Asia',
			data: [502, 635, 809, 947, 1402, 3634, 5268]
		}, {
			name: 'Africa',
			data: [106, 107, 111, 133, 221, 767, 1766]
		}, {
			name: 'Europe',
			data: [163, 203, 276, 408, 547, 729, 628]
		}, {
			name: 'America',
			data: [18, 31, 54, 156, 339, 818, 1201]
		}, {
			name: 'Oceania',
			data: [2, 2, 2, 6, 13, 30, 46]
		}]
	});
	
	
});



var chart2;
			$(function() {
				chart2 = new Highcharts.Chart({
					chart: {
						renderTo: 'report_test_2'
					},
					title: {
						text: 'Combination chart'
					},
					xAxis: {
						categories: ['Apples', 'Oranges', 'Pears', 'Bananas', 'Plums']
					},
					tooltip: {
						formatter: function() {
							var s;
							if (this.point.name) { // the pie chart
								s = ''+
									this.point.name +': '+ this.y +' fruits';
							} else {
								s = ''+
									this.x  +': '+ this.y;
							}
							return s;
						}
					},
					labels: {
						items: [{
							html: 'Total fruit consumption',
							style: {
								left: '40px',
								top: '8px',
								color: 'black'				
							}
						}]
					},
					series: [{
						type: 'column',
						name: 'Jane',
						data: [3, 2, 1, 3, 4]
					}, {
						type: 'column',
						name: 'John',
						data: [2, 3, 5, 7, 6]
					}, {
						type: 'column',
						name: 'Joe',
						data: [4, 3, 3, 9, 0]
					}, {
						type: 'spline',
						name: 'Average',
						data: [3, 2.67, 3, 6.33, 3.33]
					}, {
						type: 'pie',
						name: 'Total consumption',
						data: [{
							name: 'Jane',
							y: 13,
							color: '#4572A7' // Jane's color
						}, {
							name: 'John',
							y: 23,
							color: '#AA4643' // John's color
						}, {
							name: 'Joe',
							y: 19,
							color: '#89A54E' // Joe's color
						}],
						center: [100, 80],
						size: 100,
						showInLegend: false
					}]
				});
				
				
			});