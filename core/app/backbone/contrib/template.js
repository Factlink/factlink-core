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
    compiledTemplate = HoganTemplates[template];
    //callback.call(this, compiledTemplate);
    return compiledTemplate;
  };

  Backbone.Marionette.TemplateCache.prototype.loadTemplate = function(template) {
    return template;
  };

  Backbone.Marionette.Renderer.renderTemplate = function(template, data) {
    return template.render(data);
  };
}());
