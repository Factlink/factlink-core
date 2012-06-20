(function(Factlink, $, _, easyXDM, window, undefined) {

$.ajax({
  url: FactlinkConfig.api + '/templates/indicator',
  dataType: 'jsonp',
  crossDomain: true,
  type: 'GET',
  jsonp: 'callback',
  success: function(data) {
    Factlink.tmpl.indicator = _.template(data);

    Factlink.el.trigger('factlink.tmpl.indicator');
  }
});

$.ajax({
  url: FactlinkConfig.api + '/templates/_channel_li',
  dataType: 'jsonp',
  crossDomain: true,
  type: 'GET',
  jsonp: 'callback',
  success: function(data) {
    Factlink.tmpl.channel_li = _.template(data);

    Factlink.el.trigger('factlink.tmpl.channel_li');
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

$.ajax({
  url: FactlinkConfig.api + '/templates/' + ( FactlinkConfig.modus === "default" ? "create" : "addToFact" ) + ".html",
  dataType: 'jsonp',
  crossDomain: true,
  type: 'GET',
  jsonp: 'callback',
  success: function( data ) {
    Factlink.prepare = new Factlink.Prepare(_.template(data));
  }
});

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
