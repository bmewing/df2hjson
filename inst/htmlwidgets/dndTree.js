HTMLWidgets.widget({

  name: 'dndTree',

  type: 'output',

  initialize: function(el, width, height) {
    //d3.select(el).select("tree-container").append("svg")
    //  .style("width", "100%")
    //  .style("height", "400px");
    return {}

  },

  renderValue: function(el, x, instance) {

    makeTree(x.data,el,x.fHeight);

  },

  resize: function(el, width, height, instance) {

  }

});
