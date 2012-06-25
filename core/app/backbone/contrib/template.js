/*
    Global Template object which loads the templates from HoganTemplates
*/
(function() {
  window.Template = {
    use: function (dir, file) {
      return HoganTemplates[dir + "/" + file];
    }
  };

  window.TemplateMixin = {
    tmpl_render: function(data,partials){
      return Backbone.Marionette.Renderer.render(this.template, data, partials)
    }
  },

  Backbone.Marionette.Renderer.render = function(template, data, partials){
    return HoganTemplates[template].render(data, partials)
  };

}());
