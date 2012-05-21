/*
    Global Template object which loads the templates from HoganTemplates
*/
(function() {
  window.Template = {
    use: function (dir, file) {
      return HoganTemplates[dir + "/" + file];
    }
  };


  Backbone.Marionette.TemplateCache.loadTemplate = function(template, callback) {
    console.info("TEMPLATE:", template)
    compiledTemplate = HoganTemplates[template];
    callback.call(this, compiledTemplate);
  };
  Backbone.Marionette.Renderer.renderTemplate = function(template, data) {
    return template.render(data);
  };
}());
