Backbone.Factlink ||= {}
class Backbone.Factlink.PlainView extends Backbone.View

  serializeData: -> this.model?.toJSON()

  render: ->
    @$el.html(this.templateRender(@serializeData()))

    if (@onRender)
      @onRender();
      @trigger('render');

    return this

_.extend(Backbone.Factlink.PlainView.prototype, TemplateMixin)
