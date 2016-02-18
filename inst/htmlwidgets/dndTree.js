HTMLWidgets.widget({

  name: 'dndTree',

  type: 'output',

  initialize: function(el, width, height) {

    return {}

  },

  renderValue: function(el, x, instance) {

    makeTree(x.data,el);

  },

  resize: function(el, width, height, instance) {

  }

});
