/*
    View.useTemplate() method which loads the mustache templates

    call this in the initialize()
*/
(function() {
  var TemplateCache = {
    get: function(dir, file) {
      var self = this;

      if ( !self.templates ) { self.templates = {}; }

        self.templates[dir] = {};

        $('#mustache-templates>.mustache-dir-' + dir ).each(function(index, element) {
          var $element = $( element );
          var filename = $element.data('filename');

          self.templates[dir][filename] = $element.html();
        });
      }

      var template = self.templates[dir][file];

      if ( !template ) {
        template = self.templates[dir][ file.indexOf("_") === 0 ? file.substr(1) : "_" + file ]
      }

      return template;
    }
  };

  Backbone.View.prototype.useTemplate = function(dir,file) {
    if (this.tmpl !== undefined) { return; }

    var self = this;

    this.tmpl = TemplateCache.get(dir, file);
    this.partials = {};

    _.each(TemplateCache.templates[dir], function(value, key) {
      self.partials[ key.replace(/^_/,'') ] = TemplateCache.get(dir, key);
    });
  };
}());