var requesting = {};

Factlink.templates = {};

Factlink.templates.getTemplate = function(str, callback) {
  if ( Factlink.tmpl[str] !== undefined ) {
    callback(Factlink.tmpl[str]);
  } else {
    Factlink.el.bind('factlink.tmpl.' + str, function() {
      if (callback) { callback(Factlink.tmpl[str]); }
    });
    if (! requesting[str] ){
      requesting[str] = true;
      $.ajax({
        url: FactlinkConfig.api + '/templates/'+str,
        dataType: 'jsonp',
        crossDomain: true,
        type: 'GET',
        jsonp: 'callback',
        success: function(data) {
          Factlink.tmpl[str] = _.template(data);
          Factlink.el.trigger('factlink.tmpl.'+str);
        }
      });
    }
  }
};

Factlink.templates.preload = function() {
  Factlink.templates.getTemplate('indicator');
  Factlink.templates.getTemplate('create',function(template){
    Factlink.prepare = new Factlink.Prepare(template);
  });
};
