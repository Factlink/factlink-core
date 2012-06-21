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
    tmpl_render: function(data){
      return Backbone.Marionette.Renderer.render(this.template, data)
    }
  },

  Backbone.Marionette.Renderer.render = function(template, data){
    return HoganTemplates[template].render(data)
  };

}());
