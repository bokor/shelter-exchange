Bridge.Object.extend(Tipped.Skins || (Tipped.Skins = {}), {
  	'tooltip': {
		border: {
	    	size: 1,
	      	color: '#f7f7f7',
	      	opacity: .35
	    },
	    color: '#fff',
	    background: {
	      	color: '#000',
	      	opacity: 0.8
	    },
	    stem: {
	    	corner: {
	        	height: 7,
	        	width: 7
	    	},
	      	center: {
	        	height: 6,
	        	width: 11
	      	}
	    },
	    shadow: { opacity: .13, blur: 2 },
	    spinner: { color: '#fff' },
		hook: 'leftmiddle',
		hideDelay: .1,
		showDelay: .1,
		fadeDuration: .5
	},
	'dialog_box' : {
		border: { size: 1, color: '#1f1f1f', opacity: .95 },
    	radius: { size: 6 },
    	background: { 
			color: [ { position: 0, color: '#898989' },{ position: .015, color: '#686766' },{ position: .48, color: '#3a3939' },{ position: .52, color: '#2e2d2d' },{ position: .54, color: '#2c2b2b' },{ position: 0.95, color: '#222' },{ position: 1, color: '#202020' } ], opacity: .9 },
    	shadow: { 
			color: '#2f2f2f', 
			offset: { 
				x: 0, 
				y: 1 
			}, 
			opacity: .4 
		},
    	spinner: { color: '#ffffff' },
		maxWidth: 680, 
		maxHeight: 500,
		inline: true, 
		closeButton: true, 
		hideOn: false, 
		hideOnClickOutside: true,
		fadeDuration: .5,  
		showOn: 'click', 
		stem: true, 
		hook: 'leftbottom',
  	},
	'map_box' : {
		border: { size: 1, color: '#1f1f1f', opacity: .95 },
    	radius: { size: 6 },
    	background: { 
			color: [ { position: 0, color: '#898989' },{ position: .015, color: '#686766' },{ position: .48, color: '#3a3939' },{ position: .52, color: '#2e2d2d' },{ position: .54, color: '#2c2b2b' },{ position: 0.95, color: '#222' },{ position: 1, color: '#202020' } ], opacity: .9 },
    	shadow: { 
			color: '#2f2f2f', 
			offset: { 
				x: 0, 
				y: 1 
			}, 
			opacity: .4 
		},
    	spinner: { color: '#ffffff' },
		inline: true, 
		fadeDuration: .5,  
		stem: true, 
		hook: 'leftmiddle',
  	}

});