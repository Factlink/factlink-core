# Global Template object which loads the templates from HoganTemplates

window.TemplateMixin =
  templateRender: (data) ->
    partials = {}
    if @partials
      partials[name] = HoganTemplates[template] for name, template of @partials
    Backbone.Marionette.Renderer.render(@template, data, partials)

underscored = (template_location)-> template_location.replace(/^(.*)\/([^_\/][^\/]*)$/, '$1/_$2')

getTemplate = (template)->
  if typeof(template) == "string"
    HoganTemplates[underscored(template)]
  else
    Hogan.compile(template.text)

Backbone.Marionette.Renderer.render = (template, data, partials) ->

  if data?
    new_data =  _.extend(data,{global: Factlink.Global})

  getTemplate(template).render(new_data, partials)
