twipsy = {};
twipsy.toElement = function(div){
  var rv = {div: $(div)};
  rv.addHint = function (hint){
    this.div.tooltip({
      live: true,
      placement: 'right',
      title: function() { return hint; }
    });
  };
  return rv;
}