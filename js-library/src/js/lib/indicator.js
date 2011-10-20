(function(Factlink, $, _, easyXDM, undefined) {
    
$.ajax({
  url: '//' + FactlinkConfig.api + '/templates/indicator',
  dataType: 'jsonp',
  crossDomain: true,
  type: 'GET',
  jsonp: 'callback',
  success: function(data) {
    Factlink.tmpl.indicator = _.template(data);
    
    Factlink.el.trigger('factlink.tmpl.indicator');
  }
});

Factlink.getTemplate = function(str, callback) {
  if ( Factlink.tmpl[str] !== undefined ) {
    callback(Factlink.tmpl[str]);
  } else {
    Factlink.el.bind('factlink.tmpl.' + str, function() {
      callback(Factlink.tmpl[str]);
    });
  }
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
