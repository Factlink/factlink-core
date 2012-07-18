# Global Template object which loads the templates from HoganTemplates

window.TemplateMixin = 
  templateRender: (data) ->
    partials = {}
    if @partials
      partials[name] = HoganTemplates[template] for name, template of @partials
    Backbone.Marionette.Renderer.render(@template, data, partials)

Backbone.Marionette.Renderer.render = (template, data, partials) ->

  if data?
    new_data =  _.extend(data,{global: Backbone.Factlink.Global})

  HoganTemplates[template].render(new_data, partials)