Bridge.Object.extend(Tipped.Skins || (Tipped.Skins = {}), {
  'default': {
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
  },
  'cloud': {
    border: {
      size: 1,
      color: [
        { position: 0, color: '#bec6d5'},
        { position: 1, color: '#b1c2e3' }
      ]
    },
    color: '#56595d',
    background: {
      color: [
        { position: 0, color: '#f6fbfd'},
        { position: 0.1, color: '#fff' },
        { position: .48, color: '#fff'},
        { position: .5, color: '#fefffe'},
        { position: .52, color: '#f7fbf9'},
        { position: .8, color: '#edeff0' },
        { position: 1, color: '#e2edf4' }
      ]
    },
    shadow: { opacity: .12 },
    closeButtonSkin: 'light'
  },

  'royalblue': {
    border: {
      color: [
        { position: 0, color: '#113d71'},
        { position: 1, color: '#1e5290' }
      ]
    },
    background: {
      color: [
        { position: 0, color: '#3a7ab8'},
        { position: .48, color: '#346daa'},
        { position: .52, color: '#326aa6'},
        { position: 1, color: '#2d609b' }
      ]
    },
    shadow: { opacity: .2 },
    color: '#f2f6f9',
    spinner: { color: '#f2f6f9' }
  },

  'limegreen': {
    border: {
      size: 1,
      color: [
        { position: 0,   color: '#5a785f' },
        { position: .05, color: '#0c7908' },
        { position: 1, color: '#587d3c' }
      ]
    },
    color: '#333',
    background: {
      color: [
        { position: 0,   color: '#b3e991' },
        { position: .02, color: '#cef8be' },
        { position: .09, color: '#7bc83f' },
        { position: .35, color: '#77d228' },
        { position: .65, color: '#85d219' },
        { position: .8,  color: '#abe041' },
        { position: 1,   color: '#c4f087' }
      ]
    },
    shadow: { blur: 1 }
  },

  'liquid' : {
    radius: { size: 6 },
    border: {
      size: 1,
      color: [
        { position: 0, color: '#454545' },
        { position: 1, color: '#101010' }
      ]
    },
    background: {
      color: [
        { position: 0, color: '#515562'},
        { position: .3, color: '#252e43'},
        { position: .48, color: '#111c34'},
        { position: .52, color: '#161e32'},
        { position: .54, color: '#0c162e'},
        { position: 1, color: '#010c28'}
      ],
      opacity: .8
    },
    shadow: { color: '#021625' },
    spinner: { color: '#ffffff' }
  },

  'dark': {
    border: {
      size: 1,
      color: '#1f1f1f',
      opacity: .95
    },
    radius: { size: 6 },
    background: {
      color: [
        { position: 0, color: '#898989' },
        { position: .015, color: '#686766' },
        { position: .48, color: '#3a3939' },
        { position: .52, color: '#2e2d2d' },
        { position: .54, color: '#2c2b2b' },
        { position: 0.95, color: '#222' },
        { position: 1, color: '#202020' }
      ],
      opacity: .9
    },
    shadow: {
      color: '#2f2f2f',
      offset: { x: 0, y: 1 },
      opacity: .4
    },
    spinner: { color: '#ffffff' }
  },

  'lavender': {
    background: {
      color: [
        { position: 0, color: '#c1c5d0' },
        { position: .001, color: '#c5c7d2' },
        { position: .05, color: '#b6bac7' },
        { position: .5, color: '#9da2b4' },
        { position: 1, color: '#7f85a0' }
      ]
    },
    color: '#f7f7f7',
    border: {
      color: [
        { position: 0, color: '#a2a9be' },
        { position: 1, color: '#6b7290' }
      ],
      size: 1
    },
    radius: 1,
    shadow: { opacity: .1 }
  },

  'salmon' : {
    background: {
      color: [
        { position: 0, color: '#fcdecd' },
        { position: .001, color: '#fde8db' },
        { position: .05, color: '#fcdecd' },
        { position: .5, color: '#fab993' },
        { position: 1, color: '#f8b38b' }
      ]
    },
    border: {
      color: [
        { position: 0, color: '#eda67b' },
        { position: 1, color: '#df946f' }
      ],
      size: 1
    },
    color: '#4f4949',
    radius: 1,
    shadow: { opacity: .1 }
  },

  'yellow': {
    border: {
      size: 1,
      color: '#f7c735'
    },
    color: '#333',
    background: '#ffffaa',
    radius: 1,
    shadow: { opacity: .05 }
  },

  'light': {
    border: {
      size: 0,
      color: '#afafaf'
    },
    background: {
      color: [
        { position: 0, color: '#fefefe' },
        { position: 1, color: '#f7f7f7' }
      ]
    },
    radius: 1,
    color: '#454545',
    shadow: { opacity: .35 },
    closeButtonSkin: 'light'
  }
});

Bridge.Object.extend(Tipped.CloseButtonSkins || (Tipped.CloseButtonSkins = {}), {
  'default': {},

  'light': {
    diameter: 17,
    border: 2,
    x: {
      diameter: 10,
      size: 2,
      opacity: 1
    },
    states: {
      'default': {
        background: {
          color: [
            { position: 0, color: '#797979' },
            { position: 0.48, color: '#717171' },
            { position: 0.52, color: '#666' },
            { position: 1, color: '#666' }
          ],
          opacity: 1
        },
        x: {
          color: '#fff',
          opacity: .95
        },
        border: {
          color: '#676767',
          opacity: 1
        }
      },
      'hover': {
        background: {
          color: [
            { position: 0, color: '#868686' },
            { position: 0.48, color: '#7f7f7f' },
            { position: 0.52, color: '#757575' },
            { position: 1, color: '#757575' }
          ],
          opacity: 1
        },
        x: {
          color: '#fff',
          opacity: 1
        },
        border: {
          color: '#767676',
          opacity: 1
        }
      }
    },
    shadow: {
      blur: 2,
      color: '#000',
      offset: {
        x: 0,
        y: 0
      },
      opacity: .4
    }
  }
});