twipsy = {};
twipsy.toElement = function(div){
  console.info('adding twipsy to ',div)
  var rv = {div: div};
  rv.addHint = function (hint){
    var self = this;
    console.info('hint for ',self.div, 'is', hint)
    $('body').tooltip({
      selector: self.div,
      placement: 'right',
      title: function() { return hint; }
    });
  };
  return rv;
}