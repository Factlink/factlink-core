/*
    Global Template object which loads the templates from HoganTemplates
*/
(function() {
  window.Template = {
    use: function (dir, file) {
      return HoganTemplates[dir + "/" + file];
    }
  };


  Backbone.Marionette.TemplateCache.prototype.loadTemplate = function(template) {
    console.info("TEMPLATE:", template)
    return HoganTemplates[template];
  };

  Backbone.Marionette.TemplateCache.prototype.compileTemplate = function(template) {
    return _.bind(template.render, template);
  };

  Backbone.Marionette.Renderer.renderTemplate = function(template, data) {
    return template.render(data);
  };
}());
