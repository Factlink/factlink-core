# Global Template object which loads the templates from HoganTemplates

window.TemplateMixin = 
  templateRender: (data) ->
    partials = {}
    if @partials
      partials[name] = HoganTemplates[template] for name, template of @partials
    Backbone.Marionette.Renderer.render(@template, data, partials)

Backbone.Marionette.Renderer.render = (template, data, partials) ->
  HoganTemplates[template].render(data, partials)